local parser = require 'parser'
local uni = require 'unicode'

local function check(err)
    return function(str)
        local s, e = pcall(parser, str)
        if type(e) ~= 'string' then
            print ''
            print '没有检查到错误'
            print(err)
            print(str)
            return false
        end
        e = uni.a2u(e)
        if not e:find(err, 1, true) then
            print ''
            print '检查到的错误不正确'
            print(err)
            print(str)
            print(e)
            return false
        end
        return true
    end
end

check '第[2]行: 不合法的实数' [[
function test takes nothing returns nothing
    local real a = .
endfunction
]]
check '第[2]行: 不合法的16进制整数' [[
function test takes nothing returns nothing
    local integer a = $G
endfunction
]]
check '第[2]行: 256进制整数必须是由1个或者4个字符组成' [[
function test takes nothing returns nothing
    local integer a = '12'
endfunction
]]
check '第[2]行: 不合法的转义字符' [[
function test takes nothing returns nothing
    local integer a = '\x'
endfunction
]]
check '第[2]行: 4个字符组成的256进制整数不能使用转义字符'  [[
function test takes nothing returns nothing
    local integer a = '\t123'
endfunction
]]

check '第[3]行: 全局变量必须在函数前定义' [[
function test takes nothing returns nothing
endfunction
globals
endglobals
]]

check '第[2]行: 常量必须初始化' [[
globals
    constant integer a
endglobals
]]

check '第[3]行: 全局变量重名 --> [a]已经定义在第[2]行' [[
globals
    integer a
    integer a
endglobals
]]
