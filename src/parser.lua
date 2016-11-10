local lpeg = require 'lpeg'
local S = lpeg.S
local P = lpeg.P
local R = lpeg.R
local C = lpeg.C
local V = lpeg.V

local line_count = 1

local nl1  = P'\r\n' + S'\r\n'
local com  = P'//' * (1-nl1)^0
local sp   = (S' \t' + P'\xEF\xBB\xBF' + com)^0
local sps  = (S' \t' + P'\xEF\xBB\xBF' + com)^1
local nl   = com^0 * nl1 / function() line_count = line_count + 1 end
local spl  = sp * nl
local ign  = sps + nl
local br1  = P'('
local br2  = P')'
local ix1  = P'['
local ix2  = P']'
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
    return ((1-nl)^1 + P(1)) / function(c) error(('line[%d]: %s:\n===========================\n%s\n==========================='):format(line_count, str, c)) end
end

local function expect(p, str)
    return p + err(str)
end

local word = sp * (real + int + bool + str + id) * sp

local exp = P{
    'exp',
    -- 由低优先级向高优先级递归
    exp   = V'op7' + V'exp7',
    exp1  = V'bra' + V'func' + V'call' + V'index' + word,
    exp2  = V'op1' + V'exp1',
    exp3  = V'op2' + V'exp2',
    exp4  = V'op3' + V'exp3',
    exp5  = V'op4' + V'exp4',
    exp6  = V'op5' + V'exp5',
    exp7  = V'op6' + V'exp6',

    -- 由于消耗了字符串,可以递归回顶层
    op1   = sp * op1 * expect(V'exp1', '符号"-"错误'),
    op2   = sp * op2 * expect(V'exp1', '符号"not"错误'),

    -- 由于不消耗字符串,只允许向下递归
    op3   = V'exp3' * (op3 * expect(V'exp3', '符号"*/"错误'))^0,
    op4   = V'exp4' * #op4 * (op4 * expect(V'exp4', '符号"+-"错误'))^0,
    op5   = V'exp5' * op5 * expect(V'exp5', '逻辑判断符错误'),
    op6   = V'exp6' * #op6 * (op6 * expect(V'exp6', '符号"and"错误'))^0,
    op7   = V'exp7' * #op7 * (op7 * expect(V'exp7', '符号"or"错误'))^0,

    -- 由于消耗了字符串,可以递归回顶层
    bra   = sp * '(' * expect(V'exp' * ')' * sp, '括号不匹配'),
    call  = word * '(' * expect(V'call2', '函数调用不正确'),
    call2 = expect(V'args', '参数不正确') * ')' * sp,
    args  = #(sp * ')') + V'exp' * V'narg',
    narg  = ',' * expect(V'exp' * V'narg', '参数不正确') + sp,
    index = word * '[' * expect(V'exp' * ']' * sp, '获取变量数组不正确'),
    func  = sp * 'function' * sps * id * sp,
}

local typedef = P{
    'def',
    def  = sp * 'type' * expect(sps * id, '变量类型定义错误') * expect(V'ext', '变量类型继承错误'),
    ext  = sps * 'extends' * sps * id,
}

local global = P{
    'global',
    global = sp * 'globals' * expect(V'gdef', '全局变量未知错误'),
    gdef   = expect(V'nval', '全局变量未知声明错误') * expect(V'gend', '缺少endglobals'),
    nval   = spl * V'val'^0,
    val    = spl + (V'const' + V'array' + V'set' + V'def') * spl,
    def    = sp * id * sps * id,
    set    = sp * V'def' * sp * '=' * expect(exp, '全局变量声明时赋值错误'),
    array  = sp * id * sps * 'array' * expect(sps * id, '全局变量数组声明错误'),
    const  = sp * 'constant' * expect(sps * V'set', '全局常量声明错误'),
    gend   = sp * 'endglobals',
}

local loc = P{
    'loc',
    loc = sp * 'local' * expect(sps * V'val', '局部变量声明错误'),
    val    = V'array' + V'set' + V'def',
    def    = id * sps * id,
    set    = id * sps * id * sp * '=' * expect(exp, '局部变量声明时赋值错误'),
    array  = id * sps * 'array' * expect(sps * id, '局部变量数组声明错误'),
}

local line = P{
    'line',
    line  = sp * ('call' * expect(V'call', 'call语法不正确') + 'set' * expect(V'set', 'set语法不正确') + 'return' * V'rtn'),
    call  = sps * expect(exp, '函数调用表达式错误'),
    set   = sps * expect(V'val', '变量不正确') * '=' * expect(exp, '变量设置表达式错误'),
    rtn   = sp * #(1-nl) * expect(exp, 'return语法不正确') + P(true),
    val   = sp * id * sp * '[' * expect(exp, '数组索引表达式错误') * ']' * sp + sp * id * sp,
}

local in_loop_count = 0
local logic = P{
    'logic',
    logic    = V'lif' + V'lloop',

    lif      = sp * 'if' * expect(V'ihead', 'if语句未知错误'),
    ihead    = nid * exp * expect(V'ithen', 'if后面没有then') * expect(V'icontent', 'if内容错误'),
    ithen    = sp * 'then' * spl,
    icontent =  V'iendif' + (spl + V'logic' + V'ielseif' + V'ielse' + V'lexit' + line) * V'icontent',
    ielseif  = sp * 'elseif' * expect(nid * exp * V'ithen', 'elseif错误'),
    ielse    = sp * 'else' * spl,
    iendif   = sp * 'endif' * spl,

    lloop    = V'lhead' * expect(V'lcontent', 'loop语句未知错误'),
    lhead    = sp * 'loop' * spl / function() in_loop_count = in_loop_count + 1 end,
    lcontent = V'lendloop' + (spl + V'logic' + V'lexit' + line) * V'lcontent',
    lexit    = sp * 'exitwhen' * expect(sps * exp, 'exitwhen表达式错误') / function(c) if in_loop_count <= 0 then err'exitwhen必须在loop内部':match(c) end end,
    lendloop = sp * 'endloop' / function() in_loop_count = in_loop_count - 1 end,
}

local func = P{
    'fct',
    fct      = V'native' + V'func',
    native   = sp * 'native' * expect(V'fhead', 'native函数未知错误'),
    func     = sp * 'function' * expect(V'fhead', '函数声明格式不正确') * expect(V'fcontent', '函数主体不正确') * expect(V'fend', '缺少endfunction'),
    fhead    = sps * expect(V'fname', '函数名称不正确') * expect(V'fargs', '函数的参数声明不正确') * expect(V'freturns', '函数的返回格式不正确'),
    fname    = sp * id * sp,
    fargs    = sp * 'takes' * sps * (V'anull' + V'anarg'),
    arg      = sp * id * sps * id * sp,
    anull    = sp * 'nothing' * sp,
    anarg    = sp * V'arg' * (',' * V'arg')^0,
    freturns = sp * 'returns' * sps * id * spl,
    fcontent = sp * expect(V'flocal', '函数局部变量区域不正确') * expect(V'flines', '函数代码区域不正确'),
    flocal   = (spl + loc)^0,
    flines   = (spl + logic + line)^0,
    fend     = sp * 'endfunction',
}

local pjass = (ign + typedef + global + func + err'语法不正确')^0

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
