local parser = require 'parser'
local uni    = require 'unicode'

local exepath = package.cpath:sub(1, package.cpath:find(';')-6)
local root = fs.path(uni.a2u(exepath)):parent_path():parent_path()
local common   = io.load(root / 'src' / 'jass' / 'common.j')
local blizzard = io.load(root / 'src' / 'jass' / 'blizzard.j')

local function check(err)
    return function(str)
        local ast, grms
        local suc, e = xpcall(function()
            ast, grms = parser(common,   'common.j',   ast)
            ast, grms = parser(blizzard, 'blizzard.j', ast)
            ast, grms = parser(str,      'war3map.j',  ast)
        end, error_handle)
        if s then
            print ''
            print '没有检查到错误'
            print(err)
            print(str)
            return false
        end
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

check '语法不正确' [[
a
]]

check '类型继承错误' [[
type loli
]]

check '类型[girl]未定义' [[
type loli extends girl
]]

check '类型[loli]重复定义 --> 已经定义在[war3map.j]第[1]行' [[
type loli extends handle
type loli extends handle
]]

check '不能重新定义本地类型' [[
type code extends handle
]]

check '缺少endglobals' [[
globals
    integer a

function test takes nothing returns nothing
endfunction
]]

check '不能使用关键字[nothing]作为函数名或变量名' [[
function nothing takes nothing returns nothing
endfunction
]]

check '不能使用关键字[call]作为函数名或变量名' [[
globals
    integer call = 0
endglobals
]]

check '缺少endglobals' [[
globals
    string a = "aa
bb
cc"
    integer b = 0
]]

check '类型[loli]未定义' [[
globals
    loli a
endglobals
]]

check '数组不能直接初始化' [[
globals
    integer array a = 1
endglobals
]]

check '常量必须初始化' [[
globals
    constant integer a
endglobals
]]

check '全局变量[a]重复定义 --> 已经定义在[war3map.j]第[2]行' [[
globals
    integer a
    integer a
endglobals
]]

check '不合法的实数' [[
function test takes nothing returns nothing
    local real a = .
endfunction
]]
check '不合法的16进制整数' [[
function test takes nothing returns nothing
    local integer a = $G
endfunction
]]
check '256进制整数必须是由1个或者4个字符组成' [[
function test takes nothing returns nothing
    local integer a = '12'
endfunction
]]
check '不合法的转义字符' [[
function test takes nothing returns nothing
    local integer a = '\x'
endfunction
]]
check '4个字符组成的256进制整数不能使用转义字符'  [[
function test takes nothing returns nothing
    local integer a = '\t123'
endfunction
]]

check '全局变量必须在函数前定义' [[
function test takes nothing returns nothing
endfunction
globals
endglobals
]]

check '全局变量必须在函数前定义' [[
function test takes nothing returns nothing
endfunction
globals
endglobals
]]

check '缺少endfunction' [[
function test takes nothing returns nothing

function test takes nothing returns nothing
endfunction
]]

check '类型[loli]未定义' [[
function test takes nothing returns nothing
    local loli a
endfunction
]]

check '局部变量[a]和函数参数重名' [[
function test takes integer a returns nothing
    local integer a
endfunction
]]

check '不能在循环外使用exitwhen' [[
function test takes nothing returns nothing
    loop
        exitwhen true
    endloop
    exitwhen true
endfunction
]]

check '不能对[integer]与[unit]做加法运算' [[
function test takes nothing returns nothing
    local unit u = null
    local string s1 = "1" + "2"
    local string s2 = "1" + null
    local integer i1 = 1 + 2
    local real r1 = 1 + 0.2
    local real r2 = 0.1 + 0.2
    local boolean b = 1 + u
endfunction
]]

check '不能对[unit]做负数运算' [[
function test takes nothing returns nothing
    local integer i = 5
    local integer i2 = - i
    local unit u = null
    local boolean b = - u
endfunction
]]

check '不能比较[integer]与[unit]是否相等' [[
function test takes nothing returns nothing
    local unit u = null
    local item it = null
    local integer i = 0
    local real r = 0.0
    local boolean b1 = i == r
    local boolean b2 = u == it
    local boolean b3 = i == u
endfunction
]]

check '不能比较[integer]与[unit]的大小' [[
function test takes nothing returns nothing
    local unit u = null
    local integer i = 0
    local real r = 0.0
    local boolean b1 = i > r
    local boolean b2 = i > u
endfunction
]]
