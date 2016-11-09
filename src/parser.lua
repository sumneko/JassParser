local lpeg = require 'lpeg'
local S = lpeg.S
local P = lpeg.P
local R = lpeg.R
local C = lpeg.C
local V = lpeg.V

local line_count = 1

local sp   = S' \t'^0
local sps  = S' \t'^1
local nl1  = P'\r\n' + S'\r\n'
local com  = P'//' * (1-nl1)^0
local nl   = com^0 * nl1 / function() line_count = line_count + 1 end
local spl  = sp * nl
local quo  = P'"'
local esc  = P'\\'
local op1  = P'-'
local op2  = S'*/'
local op3  = S'+-'
local op4  = S'><=!' * P'=' + S'><'
local op5  = P'and' + P'or'
local int1 = (P'-' * sp)^-1 * (P'0' + R'19' * R'09'^0)
local int2 = (P'$' + P'0' * S'xX') * R('af', 'AF', '09')^1
local int  = int2 + int1
local real = P'-'^-1 * (P'.' * R'09' + R'09' * P'.' * R'09'^0)
local bool = P'true' + P'false'
local str1 = esc * P(1) + (1-quo)
local str  = quo * (nl + str1)^0 * quo
local id   = R('az', 'AZ') * R('az', 'AZ', '09', '__')^0

local function err(str)
    return (1-nl)^0 / function(c) error(('line[%d]: %s:\n===========================\n%s\n==========================='):format(line_count, str, c)) end
end

local word = sp * (int + real + bool + str + id) * sp

local exp = P{
    'exp',
    exp   = V'exp1' + err'表达式不正确',
    exp1  = V'op1' + V'exp2',
    exp2  = V'op2' + V'exp3',
    exp3  = V'op3' + V'exp4',
    exp4  = V'op4' + V'exp5',
    exp5  = V'op5' + V'exp6',
    exp6  = V'bra' + V'call' + V'index' + word,
    bra   = sp * '(' * (V'exp' * ')' * sp + err'括号不匹配'),
    op1   = sp * op1 * (V'exp2' + err'数学运算错误1'),
    op2   = V'exp3' * (op2 * (V'exp3' + err'数学运算错误2'))^0,
    op3   = V'exp4' * (op3 * (V'exp4' + err'数学运算错误3'))^0,
    op4   = V'exp5' * op4 * (V'exp5' + err'逻辑判断符错误'),
    op5   = V'exp6' * (op5 * (V'exp6' + err'逻辑连接符错误'))^0,
    args  = V'exp' * (',' * (sp * V'exp' + err'函数调用的参数错误'))^0,
    call  = word * '(' * (V'call1' + V'call2' + err'函数调用不正确'),
    call1 = sp * ')' * sp,
    call2 = V'args' * ')' * sp,
    index = word * '[' * (V'exp' * ']' * sp + err'获取变量数组不正确'),
}

local global = P{
    'global',
    global = sp * 'globals' * (V'nval' * V'gend' + err'全局变量未知错误'),
    nval   = spl * V'val'^0 + err'全局变量未知声明错误',
    val    = spl + (V'const' + V'array' + V'set' + V'def') * spl,
    def    = sp * id * sps * id,
    set    = sp * V'def' * sp * '=' * (exp + err'全局变量声明时赋值错误'),
    array  = sp * id * sps * 'array' * (sps * id + err'全局变量数组声明错误'),
    const  = sp * 'constant' * (sps * V'set' + err'全局常量声明错误'),
    gend   = sp * 'endglobals' * spl + err'全局变量结束符错误',
}

local loc = P{
    'loc',
    loc = sp * 'local' * (sps * V'val' + err'局部变量声明错误'),
    val    = V'array' + V'set' + V'def',
    def    = sp * id * sps * id * spl,
    set    = sp * id * sps * id * sp * '=' * exp * spl,
    array  = sp * 'array' * (sps * id + err'局部变量数组声明错误') * spl,
}

local line = P{
    'line',
    line  = sp * ('call' * V'call' + 'set' * V'set' + 'return' * V'rtn'),
    call  = sps * exp * spl + err'call语法不正确',
    set   = sps * V'val' * '=' * exp * spl + err'set语法不正确',
    rtn   = spl + sps * exp * spl + err'return语法不正确',
    val   = sp * id * sp * '[' * exp * ']' * sp + sp * id * sp + err'变量不正确',
}

local logic = P{
    'logic',
    logic     = sp * 'if' * (V'lif' * V'lthen' * V'lcontent' * V'lend' + err'if语句未知错误'),
    lif       = sps * exp + err'if表达式不正确',
    lthen     = sp * 'then' * spl + err'if后面没有then',
    lcontent  = (spl + V'lelseif' + V'lelse' + line)^0,
    lelseif   = sp * 'elseif' * (V'lif' * V'lthen' * V'lcontent' + err'elseif错误'),
    lelse     = sp * 'else' * (spl * line^0 + err'else错误'),
    lend      = sp * 'endif' * spl + 'if结尾没有endif',
}

local func = P{
    'fct',
    fct      = V'native' + V'func',
    native   = sp * 'native' * (V'fhead' + err'native函数未知错误'),
    func     = sp * 'function' * (V'fhead' * V'fcontent' * V'fend' + err'自定义函数未知错误'),
    fhead    = sps * V'fname' * V'fargs' * V'freturns' + err'函数声明格式不正确',
    fname    = sp * id * sp + err'函数名称不正确',
    fargs    = sp * 'takes' * sps * (V'anull' + V'anarg') + err'函数的参数声明不正确',
    arg      = sp * id * sps * id * sp,
    anull    = sp * 'nothing' * sp,
    anarg    = sp * V'arg' * (',' * V'arg')^0,
    freturns = sp * 'returns' * sps * id * spl + err'函数的返回格式不正确',
    fcontent = sp * V'flocal' * V'flines' + err'函数主体不正确',
    flocal   = loc^0 + err'函数局部变量区域不正确',
    flines   = (spl + logic + line)^0 + err'函数代码区域不正确',
    fend     = sp * 'endfunction' * spl + err'函数结束符不正确',
}

local mt = {}
setmetatable(mt, mt)

mt.err    = err
mt.word   = word
mt.exp    = exp
mt.global = global
mt.loc    = loc
mt.line   = line
mt.logic  = logic
mt.func   = func

function mt:__call(jass)
    ((spl + global + func)^0):match(jass)
    print('通过', line_count)
    print('用时', os.clock())
end

return mt
