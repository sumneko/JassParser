local convert_lua = require 'convert_lua'
local uni = require 'unicode'

local function check(err)
    return function(str)
        local s, e = pcall(convert_lua, str)
        if s then
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

check '第[1]行: 语法不正确' [[
a
]]

check '第[1]行: 类型继承错误' [[
type loli
]]

check '第[1]行: 类型[girl]未定义' [[
type loli extends girl
]]

check '第[2]行: 类型[loli]重复定义 --> 已经定义在[war3map.j]第[1]行' [[
type loli extends handle
type loli extends handle
]]

check '第[1]行: 不能重新定义本地类型' [[
type code extends handle
]]

check '第[4]行: 缺少endglobals' [[
globals
    integer a

function test takes nothing returns nothing
endfunction
]]

check '第[1]行: 不能使用关键字[nothing]作为函数名或变量名' [[
function nothing takes nothing returns nothing
endfunction
]]

check '第[2]行: 不能使用关键字[call]作为函数名或变量名' [[
globals
    integer call = 0
endglobals
]]

check '第[2]行: 类型[loli]未定义' [[
globals
    loli a
endglobals
]]

check '第[2]行: 数组不能直接初始化' [[
globals
    integer array a = 1
endglobals
]]

check '第[2]行: 常量必须初始化' [[
globals
    constant integer a
endglobals
]]

check '第[3]行: 全局变量[a]重复定义 --> 已经定义在[war3map.j]第[2]行' [[
globals
    integer a
    integer a
endglobals
]]

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

check '第[3]行: 全局变量必须在函数前定义' [[
function test takes nothing returns nothing
endfunction
globals
endglobals
]]

check '第[3]行: 缺少endfunction' [[
function test takes nothing returns nothing

function test takes nothing returns nothing
endfunction
]]
