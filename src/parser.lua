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

local word = Ct(sp * Cg(real + int + bool + str, 'value') * sp * keyvalue('type', 'value'))

local exp = P{
    'exp',
    
    -- 由低优先级向高优先级递归
    exp      = V'op_or',
    sub_exp  = V'bra' + V'func' + V'call' + V'id' + word,

    -- 由于不消耗字符串,只允许向下递归
    op_or    = V'op_and' * (keyvalue('type', 'or') * Cg(op_or, 'symbol') * expect(V'op_and', '符号"or"错误'))^0,
    op_and   = V'op_rel' * (keyvalue('type', 'and') * Cg(op_and, 'symbol') * expect(V'op_rel', '符号"and"错误'))^0,
    op_rel   = V'op_add' * (keyvalue('type', 'is') * Cg(op_rel, 'symbol') * expect(V'op_add', '逻辑判断符错误'))^-1,
    op_add   = V'op_mul' * (keyvalue('type', 'plus') * Cg(op_add, 'symbol') * expect(V'op_mul', '符号"+-"错误'))^0,
    op_mul   = V'op_not' * (keyvalue('type', 'multiply') * Cg(op_mul, 'symbol') * expect(V'op_not', '符号"*/"错误'))^0,

    -- 由于消耗了字符串,可以递归回顶层
    op_not   = Ct(keyvalue('type', 'not') * sp * Cg(op_not, 'symbol') * expect(Cg((V'op_not' + V'sub_exp'), 'exp'), '符号"not"错误')) + sp * V'sub_exp',

    -- 由于消耗了字符串,可以递归回顶层
    bra   = Ct(keyvalue('type', 'brackets') * sp * br1 * expect(Cg(V'exp', 'exp'), '括号内的表达式错误') * br2 * sp),
    call  = Ct(keyvalue('type', 'call') * sp * Cg(id, 'name') * br1 * expect(Cg(V'args', 'args'), '函数的参数不正确')),
    args  = Ct(sp * br2 * sp + expect(V'exp', '函数的参数1不正确') * V'narg'),
    narg  = sp * br2 * sp + expect(P',', '后续参数要用","分割') * expect(V'exp', '函数的后续参数不正确') * V'narg',
    id    = Ct(keyvalue('type', 'variable') * sp * Cg(id, 'name') * sp * (ix1 * expect(Cg(V'exp', 'index'), '索引表达式不正确') * ix2 * sp + P(true))),
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
        * (sp * '=' * expect(Cg(exp, 'exp')) + P(true)))
        ,
}

local loc = P{
    'loc',
    loc = Ct(sp * 'local' * expect(sps * V'val', '局部变量声明错误')),
    val    = V'array' + V'set' + V'def',
    def    = Cg(id, 'type') * sps * Cg(id, 'name'),
    set    = Cg(id, 'type') * sps * Cg(id, 'name') * sp * '=' * sp * expect(Cg(exp, 'exp'), '局部变量声明时赋值错误'),
    array  = Cg(id, 'type') * sps * 'array' * keyvalue('array', true) * expect(sps * Cg(id, 'name'), '局部变量数组声明错误'),
}

local line = P{
    'line',
    line  = sp * ('call' * expect(V'call', 'call语法不正确') + 'set' * expect(V'set', 'set语法不正确') + 'return' * V'rtn'),
    call  = Ct(sps * keyvalue('type', 'call') * expect(Cg(exp, 'exp'), '函数调用表达式错误')),
    set   = Ct(sps * keyvalue('type', 'set') * expect(V'val', '变量不正确') * '=' * expect(Cg(exp, 'exp'), '变量设置表达式错误')),
    rtn   = Ct(keyvalue('type', 'return') * (sp * #(1-nl) * expect(Cg(exp, 'exp'), 'return语法不正确') + P(true))),
    val   = sp * Cg(id, 'name') * sp * '[' * expect(Cg(exp, 'index'), '数组索引表达式错误') * ']' * sp + sp * Cg(id, 'name') * sp,
}

local logic = P{
    'logic',
    logic    = V'iif' + V'lloop',

    iif      = Ct(sp * 'if' * keyvalue('type', 'if') * V'ichunk' * V'iendif'),
    ichunk   = V'ifif' * V'ielseif'^0 * V'ielse'^-1,
    ifif     = Ct(V'ihead' * V'icontent'),
    ihead    = nid * Cg(exp, 'exp') * expect(V'ithen', 'if后面没有then'),
    ithen    = sp * 'then' * spl,
    icontent = (spl + V'logic' + V'lexit' + line)^0,
    ielseif  = Ct(sp * 'elseif' * V'ihead' * V'icontent'),
    ielse    = Ct(sp * 'else' * spl * V'icontent'),
    iendif   = sp * 'endif' * spl,

    lloop    = Ct(V'lhead' * keyvalue('type', 'loop') * V'lcontent' * V'lendloop'),
    lhead    = sp * 'loop' * spl,
    lcontent = (spl + V'logic' + V'lexit' + line)^0,
    lexit    = Ct(sp * 'exitwhen' * keyvalue('type', 'exit') * expect(sps * Cg(exp, 'exp'), 'exitwhen表达式错误') * spl),
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

local pjass = (ign + typedef + global + func + err'语法不正确')^0

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
