local lpeg = require 'lpeg'
local S = lpeg.S
local P = lpeg.P
local R = lpeg.R
local C = lpeg.C
local V = lpeg.V

local line_count = 1

local sp   = (S' \t' + P'\xEF\xBB\xBF')^0
local sps  = (S' \t' + P'\xEF\xBB\xBF')^1
local nl1  = P'\r\n' + S'\r\n'
local com  = P'//' * (1-nl1)^0
local nl   = com^0 * nl1 / function() line_count = line_count + 1 end
local spl  = sp * nl
local ign  = sp * (nl + com)
local quo  = P'"'
local iquo = P"'"
local esc  = P'\\'
local op1  = P'-'
local op2  = P'not'
local op3  = S'*/'
local op4  = S'+-'
local op5  = S'><=!' * P'=' + S'><'
local op6  = P'and'
local op7  = P'or'
local int1 = (P'-' * sp)^-1 * (P'0' + R'19' * R'09'^0)
local int2 = (P'$' + P'0' * S'xX') * R('af', 'AF', '09')^1
local int_ = esc * P(1) + (1-iquo)
local int3 = iquo * int_^1^-4 * iquo
local int  = int3 + int2 + int1
local real = (P'-' * sp)^-1 * (P'.' * R'09'^1 + R'09'^1 * P'.' * R'09'^0)
local bool = P'true' + P'false'
local str1 = esc * P(1) + (1-quo)
local str  = quo * (nl + str1)^0 * quo
local id   = R('az', 'AZ') * R('az', 'AZ', '09', '__')^0
local nid  = #(1-id)

local function err(str)
    return (1-nl)^0 / function(c) error(('line[%d]: %s:\n===========================\n%s\n==========================='):format(line_count, str, c)) end
end

local function errs(str)
    return (1-nl)^1 / function(c) error(('line[%d]: %s:\n===========================\n%s\n==========================='):format(line_count, str, c)) end
end

local word = sp * (real + int + bool + str + id) * sp

local exp = P{
    'exp',
    -- 由低优先级向高优先级递归
    exp   = V'op7' + V'exp7',
    exp1  = (V'bra' + V'func' + V'call' + V'index' + word) * com^-1 + errs'表达式不正确',
    exp2  = V'op1' + V'exp1',
    exp3  = V'op2' + V'exp2',
    exp4  = V'op3' + V'exp3',
    exp5  = V'op4' + V'exp4',
    exp6  = V'op5' + V'exp5',
    exp7  = V'op6' + V'exp6',

    -- 由于消耗了字符串,可以递归回顶层
    op1   = sp * op1 * (V'exp1' + err'符号"-"错误'),
    op2   = sp * op2 * (V'exp1' + err'符号"not"错误'),

    -- 由于不消耗字符串,只允许向下递归
    op3   = V'exp3' * (op3 * (V'exp3' + err'符号"*/"错误'))^0,
    op4   = V'exp4' * (op4 * (V'exp4' + err'符号"+-"错误'))^0,
    op5   = V'exp5' * op5 * (V'exp5' + err'逻辑判断符错误'),
    op6   = V'exp6' * (op6 * (V'exp6' + err'符号"and"错误'))^0,
    op7   = V'exp7' * (op7 * (V'exp7' + err'符号"or"错误'))^0,

    -- 由于消耗了字符串,可以递归回顶层
    bra   = sp * '(' * (V'exp' * ')' * sp + err'括号不匹配'),
    call  = word * '(' * (V'args' * ')' * sp + err'函数调用不正确'),
    args  = #(sp * ')') + V'exp' * V'narg' + err'参数不正确',
    narg  = ',' * (V'exp' * V'narg' + err'参数不正确') + sp,
    index = word * '[' * (V'exp' * ']' * sp + err'获取变量数组不正确'),
    func  = sp * 'function' * sps * id * sp,
}

local typedef = P{
    'def',
    def  = sp * 'type' * (sps * id + err'变量类型定义错误') * V'ext',
    ext  = sps * 'extends' * sps * id + err'变量类型继承错误',
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
    gend   = sp * 'endglobals' + err'全局变量结束符错误',
}

local loc = P{
    'loc',
    loc = sp * 'local' * (sps * V'val' + err'局部变量声明错误'),
    val    = V'array' + V'set' + V'def',
    def    = id * sps * id,
    set    = id * sps * id * sp * '=' * exp,
    array  = id * sps * 'array' * (sps * id + err'局部变量数组声明错误'),
}

local line = P{
    'line',
    line  = sp * ('call' * V'call' + 'set' * V'set' + 'return' * V'rtn'),
    call  = sps * exp + err'call语法不正确',
    set   = sps * V'val' * '=' * exp + err'set语法不正确',
    rtn   = sp * #(1-nl) * (exp + err'return语法不正确') + P(true),
    val   = sp * id * sp * '[' * exp * ']' * sp + sp * id * sp + err'变量不正确',
}

local in_loop_count = 0
local logic = P{
    'logic',
    logic    = V'lif' + V'lloop',

    lif      = sp * 'if' * (nid * exp * V'ithen' * V'icontent' + err'if语句未知错误'),
    ithen    = sp * 'then' * spl + err'if后面没有then',
    icontent =  V'iendif' + (spl + V'logic' + V'ielseif' + V'ielse' + V'lexit' + line) * V'icontent' + err'if内容错误',
    ielseif  = sp * 'elseif' * (nid * exp * V'ithen' + err'elseif错误'),
    ielse    = sp * 'else' * spl,
    iendif   = sp * 'endif' * spl,

    lloop    = V'lhead' * (V'lcontent' + err'loop语句未知错误'),
    lhead    = sp * 'loop' * spl / function() in_loop_count = in_loop_count + 1 end,
    lcontent = V'lendloop' + (spl + V'logic' + V'lexit' + line) * V'lcontent' + err'loop内容错误',
    lexit    = sp * 'exitwhen' * (sps * exp + err'exitwhen错误') / function(c) if in_loop_count <= 0 then err'exitwhen必须在loop内部':match(c) end end,
    lendloop = sp * 'endloop' / function() in_loop_count = in_loop_count - 1 end,
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
    flocal   = (spl + loc)^0 + err'函数局部变量区域不正确',
    flines   = (spl + logic + line)^0 + err'函数代码区域不正确',
    fend     = sp * 'endfunction' + err'函数结束符不正确',
}

local pjass = (ign + typedef + global + func + errs'语法不正确')^0

local mt = {}
setmetatable(mt, mt)

mt.err    = err
mt.spl    = spl
mt.ign    = ign
mt.word   = word
mt.exp    = exp
mt.global = global
mt.loc    = loc
mt.line   = line
mt.logic  = logic
mt.func   = func
mt.pjass  = pjass

function mt:line_count(n)
    if n then
        line_count = n
    else
        return line_count
    end
end

function mt:__call(jass)
    pjass:match(jass)
    print('通过', line_count)
    print('用时', os.clock())
end

return mt
