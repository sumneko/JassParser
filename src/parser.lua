local lpeg = require 'lpeg'

local tonumber = tonumber
local table_concat = table.concat

lpeg.locale(lpeg)

local S = lpeg.S
local P = lpeg.P
local R = lpeg.R
local C = lpeg.C
local V = lpeg.V
local Cg = lpeg.Cg
local Ct = lpeg.Ct
local Cc = lpeg.Cc
local Cs = lpeg.Cs

local line_count = 1

local function toint1(neg, n)
    if neg then
        return - tonumber(n)
    else
        return tonumber(n)
    end
end

local function toint2(neg, n)
    if neg then
        return - tonumber('0x'..n)
    else
        return tonumber('0x'..n)
    end
end

local function toint3(neg, n)
    if neg then
        return - ('>I'..#n):unpack(n)
    else
        return ('>I'..#n):unpack(n)
    end
end

local function toreal(neg, n)
    if neg then
        return - tonumber(n)
    else
        return tonumber(n)
    end
end

local function tostr(...)
    return table_concat {...}
end

local nl1  = P'\r\n' + S'\r\n'
local com  = P'//' * (1-nl1)^0
local sp   = (S' \t' + P'\xEF\xBB\xBF' + com)^0
local sps  = (S' \t' + P'\xEF\xBB\xBF' + com)^1
local nl   = com^0 * nl1 / function() line_count = line_count + 1 end
local spl  = sp * nl
local ign  = sps + nl
local par1 = P'('
local par2 = P')'
local ix1  = P'['
local ix2  = P']'
local quo  = P'"'
local iquo = P"'"
local esc  = P'\\'
local neg  = P'-'
local op_not = P'not'
local op_mul = S'*/'
local op_add = S'+-'
local op_rel = S'><=!' * P'=' + S'><'
local op_and = P'and'
local op_or  = P'or'
local int1 = (C(P'-' * sp) + Cc(false)) * C(P'0' + R'19' * R'09'^0) / toint1
local int2 = (C(P'-' * sp) + Cc(false)) * (P'$' + P'0' * S'xX') * C(R('af', 'AF', '09')^1) / toint2
local int_ = esc * P(1) + (1-iquo)
local int3 = (C(P'-' * sp) + Cc(false)) * iquo * C(int_^1^-4) * iquo / toint3
local int  = int3 + int2 + int1
local real = (C(P'-' * sp) + Cc(false)) * C(P'.' * R'09'^1 + R'09'^1 * P'.' * R'09'^0) / toreal
local bool = P'true' * Cc(true) + P'false' * Cc(false)
local str1 = esc * C(P(1)) + C(1-quo)
local str  = quo * C((nl1 + str1)^0) * quo
local null = P'null'
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

local function binary(...)
    local e1, op = ...
    if not op then
        return e1
    end
    local args = {...}
    local e1 = args[1]
    for i = 2, #args, 2 do
        op, e2 = args[i], args[i+1]
        e1 = {
            type = op,
            [1] = e1,
            [2] = e2,
        }
    end
    return e1
end

local real = Ct(Cg(real, 1) * keyvalue('type', 'real'))
local int  = Ct(Cg(int, 1) * keyvalue('type', 'integer'))
local bool = Ct(Cg(bool, 1) * keyvalue('type', 'boolean'))
local str  = Ct(Cg(str, 1) * keyvalue('type', 'string'))
local null = Ct(Cg(null, 1) * keyvalue('type', 'null'))

local word = sp * (null + real + int + bool + str) * sp

local exp = P{
    'exp',
    
    -- 由低优先级向高优先级递归
    exp      = V'op_or',
    sub_exp  = V'paren' + V'func' + V'call' + word + V'vari' + V'var' + V'neg',

    -- 由于不消耗字符串,只允许向下递归
    op_or    = V'op_and' * (C(op_or) * expect(V'op_and', '符号"or"错误'))^0 / binary,
    op_and   = V'op_rel' * (C(op_and) * expect(V'op_rel', '符号"and"错误'))^0 / binary,
    op_rel   = V'op_add' * (C(op_rel) * expect(V'op_add', '逻辑判断符错误'))^0 / binary,
    op_add   = V'op_mul' * (C(op_add) * expect(V'op_mul', '符号"+-"错误'))^0 / binary,
    op_mul   = V'op_not' * (C(op_mul) * expect(V'op_not', '符号"*/"错误'))^0 / binary,

    -- 由于消耗了字符串,可以递归回顶层
    op_not   = Ct(keyvalue('type', 'not') * sp * op_not * expect((V'op_not' + V'sub_exp'), '符号"not"错误')) + sp * V'sub_exp',

    -- 由于消耗了字符串,可以递归回顶层
    paren = Ct(keyvalue('type', 'paren') * sp * par1 * expect(Cg(V'exp', 1), '括号内的表达式错误') * par2 * sp),
    call  = Ct(keyvalue('type', 'call') * sp * Cg(id, 'name') * par1 * V'args' * par2 * sp),
    args  = V'exp' * (',' * V'exp')^0 + sp,
    vari  = Ct(keyvalue('type', 'vari') * sp * Cg(id, 'name') * sp * ix1 * expect(Cg(V'exp', 1), '索引表达式不正确') * ix2 * sp),
    var   = Ct(keyvalue('type', 'var') * sp * Cg(id, 'name') * sp),
    neg   = Ct(keyvalue('type', 'neg') * sp * neg * sp * Cg(V'sub_exp', 1)),
    func  = Ct(sp * 'function' * keyvalue('type', 'function') * sps * Cg(id, 'name') * sp),
}

local typedef = P{
    'def',
    def  = Ct(sp * 'type' * expect(sps * Cg(id, 'name'), '变量类型定义错误') * expect(V'ext', '变量类型继承错误') * keyvalue('type', 'type')),
    ext  = sps * 'extends' * sps * Cg(id, 'extends'),
}

local global = P{
    'global',
    global = Ct(sp * 'globals' * spl * expect(V'vals', '全局变量未知错误') * keyvalue('type', 'globals') * expect('endglobals', '缺少endglobals')),
    vals   = (spl + V'def')^0,
    def    = Ct(sp
        * ('constant' * sps * keyvalue('constant', true) + P(true))
        * Cg(id, 'type') * sps
        * ('array' * sps * keyvalue('array', true) + P(true))
        * Cg(id, 'name')
        * (sp * '=' * expect(Cg(exp)) + P(true)))
        ,
}

local loc = P{
    'loc',
    loc = Ct(sp * 'local' * expect(sps * V'val', '局部变量声明错误')),
    val    = V'array' + V'set' + V'def',
    def    = Cg(id, 'type') * sps * Cg(id, 'name'),
    set    = Cg(id, 'type') * sps * Cg(id, 'name') * sp * '=' * sp * expect(Cg(exp, 1), '局部变量声明时赋值错误'),
    array  = Cg(id, 'type') * sps * 'array' * keyvalue('array', true) * expect(sps * Cg(id, 'name'), '局部变量数组声明错误'),
}

local line = P{
    'line',
    line  = sp * (V'call' + V'set' + V'seti' + V'rtn'),
    call  = Ct(keyvalue('type', 'call') * 'call' * sps * Cg(id, 'name') * sp * par1 * V'args' * par2 * sp),
    args  = exp * (',' * exp)^0 + sp,
    set   = Ct(keyvalue('type', 'set') * 'set' * sps * expect(Cg(id, 'name'), '变量不正确') * sp * '=' * expect(exp, '变量设置表达式错误')),
    seti  = Ct(keyvalue('type', 'seti') * 'set' * sps * expect(Cg(id, 'name'), '变量不正确') * sp * '[' * expect(Cg(exp, 1), '数组索引表达式错误') * ']' * sp * '=' * expect(Cg(exp, 2), '变量设置表达式错误')),
    rtn   = Ct(keyvalue('type', 'return') * 'return' * (sp * #(1-nl) * expect(Cg(exp, 1), 'return语法不正确') + P(true))),
}

local logic = P{
    'logic',
    logic    = V'iif' + V'lloop',

    iif      = Ct(sp * 'if' * keyvalue('type', 'if') * V'ichunk' * V'iendif'),
    ichunk   = V'ifif' * V'ielseif'^0 * V'ielse'^-1,
    ifif     = Ct(V'ihead' * V'icontent'),
    ihead    = nid * Cg(exp, 'condition') * expect(V'ithen', 'if后面没有then'),
    ithen    = sp * 'then' * spl,
    icontent = (spl + V'logic' + V'lexit' + line)^0,
    ielseif  = Ct(sp * 'elseif' * V'ihead' * V'icontent'),
    ielse    = Ct(sp * 'else' * spl * V'icontent'),
    iendif   = sp * 'endif' * spl,

    lloop    = Ct(V'lhead' * keyvalue('type', 'loop') * V'lcontent' * V'lendloop'),
    lhead    = sp * 'loop' * spl,
    lcontent = (spl + V'logic' + V'lexit' + line)^0,
    lexit    = Ct(sp * 'exitwhen' * keyvalue('type', 'exit') * expect(sps * Cg(exp, 1), 'exitwhen表达式错误') * spl),
    lendloop = sp * 'endloop' * spl,
}

local func = P{
    'fct',
    fct      = Ct((V'native' + V'func') * keyvalue('type', 'function')),
    native   = sp * (P'constant' * keyvalue('constant', true))^-1 * sp * 'native' * keyvalue('native', true) * expect(V'fhead', 'native函数未知错误'),
    func     = sp * 'function' * expect(V'fhead', '函数声明格式不正确') * expect(V'fcontent', '函数主体不正确') * expect(V'fend', '缺少endfunction'),
    fhead    = sps * expect(V'fname', '函数名称不正确') * expect(V'fargs', '函数的参数声明不正确') * expect(V'freturns', '函数的返回格式不正确'),
    fname    = sp * Cg(id, 'name') * sp,
    fargs    = sp * 'takes' * sps * (V'anull' + Cg(V'anarg', 'args')),
    arg      = Ct(sp * Cg(id, 'type') * sps * Cg(id, 'name') * sp),
    anull    = sp * 'nothing' * sp,
    anarg    = Ct(sp * V'arg' * (',' * V'arg')^0),
    freturns = sp * 'returns' * sps * ('nothing' + Cg(id, 'returns')) * spl,
    fcontent = sp * expect(Cg(V'flocal', 'locals'), '函数局部变量区域不正确') * expect(V'flines', '函数代码区域不正确'),
    flocal   = Ct((spl + loc)^0),
    flines   = (spl + logic + line)^0,
    fend     = sp * 'endfunction',
}

local pjass = (ign + global)^0 * (ign + typedef + func + err'语法不正确')^0

local mt = {}
setmetatable(mt, mt)

mt.err    = err
mt.spl    = spl
mt.ign    = ign
mt.word   = word
mt.id     = id
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
    local t = Ct(pjass):match(jass)
    return t
end

return mt
