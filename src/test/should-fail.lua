-- 外部单元测试
local parser = require 'parser'
local check_path = fs.current_path() / 'src' / 'should-fail'

local function check_str(str, name)
    local suc, res = xpcall(parser.parser, debug.traceback, str, 'war3map.j')
    if suc then
        error(([[
%s

[%s]没有识别出错误:
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
    local str = io.load(path)
    check_str(str, file_name)
end
