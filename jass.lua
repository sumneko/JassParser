-- 检查单个脚本文件，会使用工具内置的common.j和blizzard.j(1.24e)

root = arg[0] .. '\\..'
package.path = package.path .. ';' .. root .. '\\src\\?.lua'
                            .. ';' .. root .. '\\src\\?\\init.lua'

require 'filesystem'
require 'utility'
local parser = require 'parser'

local function main()
    os.execute('chcp 65001')
    if not arg[1] then
        print('请输入脚本路径')
        return
    end
    local root     = fs.path(root)
    local path     = fs.path(arg[1])
    local jass     = io.load(path)
    local common   = io.load(root / 'src' / 'jass' / 'common.j')
    local blizzard = io.load(root / 'src' / 'jass' / 'blizzard.j')

    local clock = os.clock()
    local suc, errors = xpcall(parser.check, debug.traceback,
                                    {common,   'common.j'},
                                    {blizzard, 'blizzard.j'},
                                    {jass,     path:filename():string()})
    if not suc then
        print(errors)
        return
    end
    local clock = os.clock() - clock
    if #errors > 0 then
        for _, error in ipairs(errors) do
            if error.level == 'warning' then
                print(parser.format_error(error))
            end
        end
        for _, error in ipairs(errors) do
            if error.level == 'error' then
                print(parser.format_error(error))
            end
        end
    end
    local len = #common + #blizzard + #jass
    print(('脚本检查完成，长度为[%.3f]k，用时[%s]，速度[%.3f]m/s'):format(len / 1000, clock, len / 1000000 / clock))
    print('完成')
end

main()
