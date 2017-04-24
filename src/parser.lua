local lpeg = require 'lpeg'
lpeg.locale(lpeg)

local S = lpeg.S
local P = lpeg.P
local R = lpeg.R
local C = lpeg.C
local V = lpeg.V
local Cg = lpeg.Cg
local Ct = lpeg.Ct
local Cc = lpeg.Cc

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
local op_not = P'not' + P'-'
local op_mul = S'*/'
local op_add = S'+-'
local op_rel = S'><=!' * P'=' + S'><'
local op_and = P'and'
local op_or  = P'or'
local int1 = (P'-' * sp)^-1 * (P'0' + R'19' * R'09'^0)
local int2 = (P'$' + P'0' * S'xX') * R('af', 'AF', '09')^1
local int_ = esc * P(1) + (1-iquo)
local int3 = iquo * int_^1^-4 * iquo
local int  = int3 + int2 + int1
local real = (P'-' * sp)^-1 * (P'.' * R'09'^1 + R'09'^1 * P'.' * R'09'^0)
local bool = P'true' + P'false'
local str1 = esc * P(1) + (1-quo)
local str  = quo * (nl1 + str1)^0 * quo
local id   = R('az', 'AZ') * R('az', 'AZ', '09', '__')^0
local nid  = #(1-id)

local function err(str)
    return ((1-nl)^1 + P(1)) / function(c) error(('line[%d]: %s:\n===========================\n%s\n==========================='):format(line_count, str, c)) end
end

local function expect(p, str)
    return p + err(str)
end

local function keyvalue(key, value)
    return Cg(Cc(value), key)
end

local word = sp * (real + int + bool + str + id) * sp

local exp = P{
    'exp',
    
    -- 由低优先级向高优先级递归
    exp      = V'op_or',
    sub_exp  = V'bra' + V'func' + V'call' + V'index' + word,

    -- 由于不消耗字符串,只允许向下递归
    op_or    = V'op_and' * (op_or * expect(V'op_and', '符号"or"错误'))^0,
    op_and   = V'op_rel' * (op_and * expect(V'op_rel', '符号"and"错误'))^0,
    op_rel   = V'op_add' * (op_rel * expect(V'op_add', '逻辑判断符错误'))^-1,
    op_add   = V'op_mul' * (op_add * expect(V'op_mul', '符号"+-"错误'))^0,
    op_mul   = V'op_not' * (op_mul * expect(V'op_not', '符号"*/"错误'))^0,

    -- 由于消耗了字符串,可以递归回顶层
    op_not   = sp * op_not * expect(V'sub_exp', '符号"not"错误') + sp * V'sub_exp',

    -- 由于消耗了字符串,可以递归回顶层
    bra   = sp * br1 * expect(V'exp', '括号内的表达式错误') * br2 * sp,
    call  = word * br1 * expect(V'args', '函数的参数不正确'),
    args  = sp * br2 * sp + expect(V'exp', '函数的参数1不正确') * V'narg',
    narg  = sp * br2 * sp + expect(P',', '后续参数要用","分割') * expect(V'exp', '函数的后续参数不正确') * V'narg',
    index = word * ix1 * expect(V'exp', '索引表达式不正确') * ix2 * sp,
    func  = sp * 'function' * sps * id * sp,
}
exp = Ct(Cg(exp, '内容') * keyvalue('类型', '表达式'))

local typedef = P{
    'def',
    def  = sp * 'type' * expect(sps * Cg(id, '名称'), '变量类型定义错误') * expect(V'ext', '变量类型继承错误'),
    ext  = sps * 'extends' * sps * Cg(id, '继承'),
}
typedef = Ct(typedef * keyvalue('类型', '类型定义'))

local global = P{
    'global',
    global = sp * 'globals' * expect(V'gdef', '全局变量未知错误'),
    gdef   = expect(V'nval', '全局变量未知声明错误') * expect(V'gend', '缺少endglobals'),
    nval   = spl * V'val'^0,
    val    = spl + Ct((V'const' + V'array' + V'set' + V'def')) * spl,
    def    = sp * Cg(id, '类型') * sps * Cg(id, '名称'),
    set    = sp * V'def' * sp * '=' * expect(Cg(exp, '初始值'), '全局变量声明时赋值错误'),
    array  = sp * Cg(id, '类型') * sps * 'array' * expect(sps * Cg(id, '名称'), '全局变量数组声明错误') * keyvalue('数组', true),
    const  = sp * 'constant' * expect(sps * V'set', '全局常量声明错误') * keyvalue('常量', true),
    gend   = sp * 'endglobals',
}
global = Ct(Cg(Ct(global), '定义') * keyvalue('类型', '全局变量'))

local loc = P{
    'loc',
    loc = sp * 'local' * expect(sps * V'val', '局部变量声明错误'),
    val    = V'array' + V'set' + V'def',
    def    = Cg(id, '类型') * sps * Cg(id, '名称'),
    set    = Cg(id, '类型') * sps * Cg(id, '名称') * sp * '=' * sp * expect(Cg(exp, '初始值'), '局部变量声明时赋值错误'),
    array  = Cg(id, '类型') * sps * 'array' * keyvalue('数组', true) * expect(sps * Cg(id, '名称'), '局部变量数组声明错误'),
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
    logic    = V'iif' + V'lloop',

    iif      = sp * 'if' * keyvalue('类型', '判断') * Ct(V'ihead') * Ct(V'ielseif')^0 * Ct(V'ielse')^-1 * V'iendif',
    ihead    = nid * Cg(exp, '条件') * expect(V'ithen', 'if后面没有then') * Cg(Ct(V'icontent')^0, '内容'),
    ithen    = sp * 'then' * spl,
    icontent = spl + V'logic' + V'lexit' + line,
    ielseif  = sp * 'elseif' * V'ihead',
    ielse    = sp * 'else' * spl * Cg(Ct(V'icontent')^0, '内容'),
    iendif   = sp * 'endif' * spl,

    lloop    = V'lhead' * expect(V'lcontent', 'loop语句未知错误'),
    lhead    = sp * 'loop' * keyvalue('类型', '循环') * spl / function() in_loop_count = in_loop_count + 1 end,
    lcontent = V'lendloop' + (spl + V'logic' + V'lexit' + line) * V'lcontent',
    lexit    = sp * 'exitwhen' * expect(sps * exp, 'exitwhen表达式错误') / function(c) if in_loop_count <= 0 then err'exitwhen必须在loop内部':match(c) end end,
    lendloop = sp * 'endloop' / function() in_loop_count = in_loop_count - 1 end,
}
logic = Ct(logic)

local func = P{
    'fct',
    fct      = V'native' + V'func',
    native   = sp * (P'constant' * keyvalue('常量', true))^-1 * sp * 'native' * keyvalue('本地函数', true) * expect(V'fhead', 'native函数未知错误'),
    func     = sp * 'function' * expect(V'fhead', '函数声明格式不正确') * expect(V'fcontent', '函数主体不正确') * expect(V'fend', '缺少endfunction'),
    fhead    = sps * expect(V'fname', '函数名称不正确') * expect(V'fargs', '函数的参数声明不正确') * expect(V'freturns', '函数的返回格式不正确'),
    fname    = sp * Cg(id, '名称') * sp,
    fargs    = sp * 'takes' * sps * (V'anull' + Cg(Ct(V'anarg'), '参数')),
    arg      = sp * Cg(id, '类型') * sps * Cg(id, '名称') * sp,
    anull    = sp * 'nothing' * keyvalue('无参数', true) * sp,
    anarg    = sp * Ct(V'arg') * (',' * Ct(V'arg'))^0,
    freturns = sp * 'returns' * sps * ('nothing' * keyvalue('无返回值', true) + Cg(id, '返回值类型')) * spl,
    fcontent = sp * expect(Cg(Ct(V'flocal'), '局部变量'), '函数局部变量区域不正确') * expect(Cg(Ct(V'flines'), '语句'), '函数代码区域不正确'),
    flocal   = (spl + loc)^0,
    flines   = (spl + logic + line)^0,
    fend     = sp * 'endfunction',
}
func = Ct(func * keyvalue('类型', '函数'))

local pjass = Ct((ign + typedef + global + func + err'语法不正确')^0)

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
    lpeg.line_count = 1
    lpeg.setmaxstack(1000)
    local t = pjass:match(jass)
    print('通过', line_count)
    print('用时', os.clock())
    return t
end

return mt
