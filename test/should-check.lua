-- 外部单元测试
local parser = require 'parser'
local check_path = fs.current_path() / 'test' / 'should-check'
local ignore = {
    ['absolute-garbage.j']  = '语法不正确',
}

local function check_result(str, name, errors)
    local has_error
    for _, error in ipairs(errors) do
        if error.level == 'error' then
            has_error = error.err
        end
    end
    if has_error then
        error(([[
%s

[%s]测试失败:
%s
%s
%s
]]):format(
    has_error,
    name,
    ('='):rep(30),
    str,
    ('='):rep(30)
))
    end
end

local function check_str(str, name)
    local ast, comments, errors = parser.parser(str, name)
    check_result(str, name, errors)
    local errors = parser.checker(str, name)
    check_result(str, name, errors)
end

for path in check_path:list_directory() do
    local file_name = path:filename():string()
    if not ignore[file_name] then
        local str = io.load(path)
        check_str(str, file_name)
    end
end
