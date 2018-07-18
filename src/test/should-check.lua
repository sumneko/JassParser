-- 外部单元测试
local parser = require 'parser'
local check_path = fs.current_path() / 'src' / 'should-check'
local ignore = {
    ['absolute-garbage.j']  = true,  -- 语法不正确
}

local function check_str(str, name)
    local suc, res = xpcall(parser.parser, debug.traceback, str, 'war3map.j')
    if not suc then
        error(([[
%s

[%s]测试失败:
%s
%s
%s
]]):format(
    res,
    name,
    ('='):rep(30),
    str,
    ('='):rep(30)
))
    end
end

for path in check_path:list_directory() do
    local file_name = path:filename():string()
    if not ignore[file_name] then
        local str = io.load(path)
        check_str(str, file_name)
    end
end
