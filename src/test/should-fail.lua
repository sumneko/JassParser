-- 外部单元测试
local parser = require 'parser'
local check_path = fs.current_path() / 'src' / 'should-fail'

local function check_str(str, name, err, lua)
    if not err and not lua then
        return
    end
    local ast, comments, errors, gram = parser.parser(str, name)
    if #errors == 0 then
        local lines = {}
        lines[#lines+1] = name .. ':未捕获错误'
        lines[#lines+1] = '=========jass========'
        lines[#lines+1] = str
        lines[#lines+1] = '=========期望========'
        lines[#lines+1] = err
        error(table.concat(lines, '\n'))
    end
    if err then
        local ok
        for _, error in ipairs(errors) do
            if err == error.err then
                ok = true
                break
            end
        end
        if not ok then
            local lines = {}
            lines[#lines+1] = name .. ':错误不正确'
            lines[#lines+1] = '=========jass========'
            lines[#lines+1] = str
            lines[#lines+1] = '=========期望========'
            lines[#lines+1] = err
            lines[#lines+1] = '=========错误========'
            lines[#lines+1] = errors[1].msg
            error(table.concat(lines, '\n'))
        end
    end
    if lua then
        local ok, err = lua(errors)
        if not ok then
            local lines = {}
            lines[#lines+1] = name .. ':错误检查失败'
            lines[#lines+1] = '=========jass========'
            lines[#lines+1] = str
            lines[#lines+1] = '=========原因========'
            lines[#lines+1] = err
            error(table.concat(lines, '\n'))
        end
    end
    return true
end

local ok = 0
local skip = 0
for path in check_path:list_directory() do
    if path:extension():string() == '.j' then
        local file_name = path:filename():string()
        local str = io.load(path)
        local err = io.load(path:parent_path() / (path:stem():string() .. '.err'))
        local lua = io.load(path:parent_path() / (path:stem():string() .. '.lua'))
        if lua then
            lua = load(lua, '@'..(path:parent_path() / (path:stem():string() .. '.lua')):string())
        end
        local suc = check_str(str, file_name, err, lua)
        if suc then
            ok = ok + 1
        else
            skip = skip + 1
        end
    end
end
print(('共检查[%d]个错误，跳过[%d]个错误'):format(ok, skip))
