-- 外部单元测试
local parser = require 'parser'
local check_path = fs.current_path() / 'src' / 'should-fail'

local function check_str(str, name, err)
    if not err then
        return
    end
    local ast, comments, errors, gram = parser.parser(str, 'war3map.j')
    if #errors == 0 then
        local lines = {}
        lines[#lines+1] = '未捕获错误'
        lines[#lines+1] = '=========jass========'
        lines[#lines+1] = str
        lines[#lines+1] = '=========期望========'
        lines[#lines+1] = err
        error(table.concat(lines, '\n'))
    end
    local ok
    for _, error in ipairs(errors) do
        if err == error.err then
            ok = true
            break
        end
    end
    if not ok then
        local lines = {}
        lines[#lines+1] = '错误不正确'
        lines[#lines+1] = '=========jass========'
        lines[#lines+1] = str
        lines[#lines+1] = '=========期望========'
        lines[#lines+1] = err
        lines[#lines+1] = '=========错误========'
        lines[#lines+1] = errors[1].err
        error(table.concat(lines, '\n'))
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
        local suc = check_str(str, file_name, err)
        if suc then
            ok = ok + 1
        else
            skip = skip + 1
        end
    end
end
print(('共检查[%d]个错误，跳过[%d]个错误'):format(ok, skip))
