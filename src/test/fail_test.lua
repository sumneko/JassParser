local parser = require 'parser'
local uni = require 'unicode'

local function check(mode, err)
    return function(str)
        local s, e = pcall(parser, str, mode)
        if type(e) ~= 'string' then
            print ''
            print '没有检查到错误'
            print(str)
            print(err)
            return false
        end
        e = uni.a2u(e)
        if not e:find(err) then
            print ''
            print '检查到的错误不正确'
            print(str)
            print(err)
            print(e)
            return false
        end
        return true
    end
end

check('Value', '不合法的实数') '.'
check('Value', '不合法的16进制整数') '$G'
check('Value', '256进制整数必须是由1个或者4个字符组成') "'12'"
check('Value', '不合法的转义字符') "'\\x'"
check('Value', '4个字符组成的256进制整数不能使用转义字符') "'\\t123'"