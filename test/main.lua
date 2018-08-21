root = arg[0] .. '\\..\\..'
package.path = package.path .. ';' .. root .. '\\src\\?.lua'
                            .. ';' .. root .. '\\src\\?\\init.lua'
                            .. ';' .. root .. '\\test\\?.lua'
                            .. ';' .. root .. '\\test\\?\\init.lua'

require 'filesystem'
require 'utility'
require 'global_protect'
local parser = require 'parser'

local function main()
    local function test(name)
        local clock = os.clock()
        print(('测试[%s]...'):format(name))
        require(name)
        print(('测试[%s]用时[%.3f]'):format(name, os.clock() - clock))
    end
    
    test 'grammar'
    test 'ast'
    test 'tests'
    
    print('测试完成')
end

if rawget(_G, 'DEBUG') then
    main()
else
    xpcall(main, function (msg)
        print(debug.traceback(msg))
    end)
end
