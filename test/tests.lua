-- 外部单元测试
local parser = require 'parser'
local format_error = parser.format_error

local function TEST_RESULT(str, filename, errors, results)
    local err = io.load(results / (filename .. '.err'))
    local warn = io.load(results / (filename .. '.warn'))
    local lua = io.load(results / (filename .. '.lua'))
    if lua then
        lua = load(lua, '@'..(results / (filename .. '.lua')):string())
    end
    if #errors == 0 then
        if not err and not warn and not lua then
            return true
        end
        local lines = {}
        lines[#lines+1] = filename .. ':未捕获错误'
        lines[#lines+1] = '=========期望========'
        lines[#lines+1] = err or warn
        lines[#lines+1] = '=========jass========'
        lines[#lines+1] = str
        error(table.concat(lines, '\n'))
    end
    if not err and not warn and not lua then
        local lines = {}
        lines[#lines+1] = filename .. ':测试失败'
        lines[#lines+1] = '=========错误========'
        lines[#lines+1] = format_error(errors[1])
        lines[#lines+1] = '=========jass========'
        lines[#lines+1] = str
        error(table.concat(lines, '\n'))
    end
    if err then
        local ok, anyErr
        for _, error in ipairs(errors) do
            if err == error.err then
                ok = error
                break
            end
            if 'error' == error.level then
                anyErr = error
            end
        end
        if not ok then
            local lines = {}
            lines[#lines+1] = filename .. ':错误不正确'
            lines[#lines+1] = '=========期望========'
            lines[#lines+1] = err
            lines[#lines+1] = '=========实际========'
            lines[#lines+1] = format_error(anyErr)
            lines[#lines+1] = '=========jass========'
            lines[#lines+1] = str
            error(table.concat(lines, '\n'))
        end
        if ok.level ~= 'error' then
            local lines = {}
            lines[#lines+1] = filename .. ':错误等级不正确'
            lines[#lines+1] = '=========期望========'
            lines[#lines+1] = 'error'
            lines[#lines+1] = '=========实际========'
            lines[#lines+1] = ok.level
            error(table.concat(lines, '\n'))
        end
    end
    if warn then
        local ok
        for _, error in ipairs(errors) do
            if 'error' == error.level then
                ok = error
                break
            end
        end
        if ok then
            local lines = {}
            lines[#lines+1] = filename .. ':错误等级不正确'
            lines[#lines+1] = '=========期望========'
            lines[#lines+1] = '[warning]'
            lines[#lines+1] = warn
            lines[#lines+1] = '=========实际========'
            lines[#lines+1] = '[error]'
            lines[#lines+1] = format_error(ok)
            error(table.concat(lines, '\n'))
        end
        local ok
        for _, error in ipairs(errors) do
            if warn == error.err then
                ok = error
                break
            end
        end
        if not ok then
            local lines = {}
            lines[#lines+1] = filename .. ':警告不正确'
            lines[#lines+1] = '=========期望========'
            lines[#lines+1] = warn
            lines[#lines+1] = '=========实际========'
            lines[#lines+1] = format_error(errors[1])
            lines[#lines+1] = '=========jass========'
            lines[#lines+1] = str
            error(table.concat(lines, '\n'))
        end
    end
    if lua then
        local ok, err = lua(errors)
        if not ok then
            local lines = {}
            lines[#lines+1] = filename .. ':错误检查失败'
            lines[#lines+1] = '=========jass========'
            lines[#lines+1] = str
            lines[#lines+1] = '=========原因========'
            lines[#lines+1] = err
            error(table.concat(lines, '\n'))
        end
    end
    return false
end

local function TEST(str, filename, results)
    if io.load(results / (filename .. '.skip')) then
        print('', ('跳过[%s]'):format(filename))
        return false
    end
    local _, _, errors, _ = parser.parser(str, filename .. '.j')
    local parserRes = TEST_RESULT(str, filename, errors, results)
    local errors = parser.checker(str, filename .. '.j')
    local checkerRes = TEST_RESULT(str, filename, errors, results)
    return parserRes and checkerRes
end

local function TEST_DIRECTORY(tests, results)
    local n = 0
    for path in tests:list_directory() do
        if path:extension():string() == '.j' then
            local filename = path:stem():string()
            local str = io.load(path)
            if TEST(str, filename, results or tests) then
                n = n + 1
            end
        end
    end
    return n
end

local root = fs.path(root) / 'test'
assert(13 == TEST_DIRECTORY(root / 'pjass-tests' / 'should-check', root / 'pjass-tests' / 'should-check-res'))
assert(0 == TEST_DIRECTORY(root / 'pjass-tests' / 'should-fail', root / 'pjass-tests' / 'should-fail-res'))

assert(13 == TEST_DIRECTORY(root / 'should-check'))
assert(0 == TEST_DIRECTORY(root / 'should-fail'))
