(function()
	local exepath = package.cpath:sub(1, (package.cpath:find(';') or #package.cpath+1)-6)
	package.path = package.path .. ';' .. exepath .. '..\\src\\?.lua'
	package.path = package.path .. ';' .. exepath .. '..\\src\\?\\init.lua'
end)()

require 'filesystem'
require 'utility'
require 'global_protect'
local parser = require 'parser'

local function main()
    if arg[1] then
        local exepath  = package.cpath:sub(1, package.cpath:find(';')-6)
        local root     = fs.path(exepath):parent_path():parent_path()
        local common   = io.load(root / 'src' / 'jass' / 'common.j')
        local blizzard = io.load(root / 'src' / 'jass' / 'blizzard.j')

        local path = fs.path(arg[1])
        local jass = io.load(path)

        local clock = os.clock()
        local suc, ast, comments, errors = xpcall(parser.parse, debug.traceback, common, blizzard, jass)
        if not suc then
            print(ast)
            return
        end
        if #errors > 0 then
            for _, error in ipairs(errors) do
                if error.level == 'error' then
                    print(parser.format_error(error))
                end
            end
        end
        local len = #common + #blizzard + #jass
        print(('脚本解析完成，长度为[%.3f]k，用时[%s]，速度[%.3f]m/s'):format(len / 1000, os.clock() - clock, len / 1000000 / (os.clock() - clock)))

        local clock = os.clock()
        local suc, errors = xpcall(parser.check, debug.traceback, common, blizzard, jass)
        if not suc then
            print(errors)
            return
        end
        if #errors > 0 then
            for _, error in ipairs(errors) do
                if error.level == 'error' then
                    print(parser.format_error(error))
                end
            end
        end
        local len = #common + #blizzard + #jass
        print(('脚本检查完成，长度为[%.3f]k，用时[%s]，速度[%.3f]m/s'):format(len / 1000, os.clock() - clock, len / 1000000 / (os.clock() - clock)))
    else
        require 'test'
    end
    print('完成')
end

if rawget(_G, 'DEBUG') then
    main()
else
    xpcall(main, function (msg)
        print(debug.traceback(msg))
    end)
end
