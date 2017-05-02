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
local Cp = lpeg.Cp
local Cmt = lpeg.Cmt

local jass
local line_count = 1
local line_pos = 1

local nl1  = P'\r\n' + S'\r\n'
local com  = P'//' * (1-nl1)^0
local sp   = (S' \t' + P'\xEF\xBB\xBF' + com)^0
local sps  = (S' \t' + P'\xEF\xBB\xBF' + com)^1
local par1 = P'('
local par2 = P')'
local ix1  = P'['
local ix2  = P']'
local neg  = P'-'
local op_not = P'not'
local op_mul = S'*/'
local op_add = S'+-'
local op_rel = S'><=!' * P'=' + S'><'
local op_and = P'and'
local op_or  = P'or'
local id   = R('az', 'AZ') * R('az', 'AZ', '09', '__')^0

local nl   = com^0 * nl1 * Cp() / function(p)
    line_count = line_count + 1
    line_pos = p
end
local spl  = sp * nl
local ign  = sps + nl
local nid  = #(1-id)

local function err(str)
    return Cp() / function(pos)
        local endpos = jass:find('[\r\n]', pos) or (#jass+1)
        local sp = (' '):rep(pos-line_pos)
        local line = ('%s|\r\n%s\r\n%s|'):format(sp, jass:sub(line_pos, endpos-1), sp)
        error(('line[%d]: %s:\n===========================\n%s\n==========================='):format(line_count, str, line))
    end
end

local function expect(p, ...)
    if select('#', ...) == 1 then
        local str = ...
        return p + err(str)
    else
        local m, str = ...
        return p + m * err(str)
    end
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

local Null = Ct(keyvalue('type', 'null') * P'null')
local Bool = P{
    'Def',
    Def   = Ct(keyvalue('type', 'boolean') * Cg(V'True' + V'False', 1)),
    True  = P'true' * Cc(true),
    False = P'false' * Cc(false),
}
local Str = P{
    'Def',
    Def  = Ct(keyvalue('type', 'string') * Cg(V'Str', 1)),
    Str  = '"' * Cs((nl1 + V'Char')^0) * '"',
    Char = V'Esc' + '\\' * err'不合法的转义字符' + (1-P'"'),
    Esc  = P'\\b' / function() return '\b' end 
         + P'\\t' / function() return '\t' end
         + P'\\r' / function() return '\r' end
         + P'\\n' / function() return '\n' end
         + P'\\f' / function() return '\f' end
         + P'\\"' / function() return '\"' end
         + P'\\\\' / function() return '\\' end,
}
local Real = P{
    'Def',
    Def  = Ct(keyvalue('type', 'real') * Cg(V'Real', 1)),
    Real = V'Neg' * V'Char' / function(neg, n) return neg and -n or n end,
    Neg   = Cc(true) * P'-' * sp + Cc(false),
    Char  = (P'.' * expect(R'09'^1, '不合法的实数') + R'09'^1 * P'.' * R'09'^0) / tonumber,
}
local Int = P{
    'Def',
    Def    = Ct(keyvalue('type', 'integer') * Cg(V'Int', 1)),
    Int    = V'Neg' * (V'Int16' + V'Int10' + V'Int256') / function(neg, n) return neg and -n or n end,
    Neg    = Cc(true) * P'-' * sp + Cc(false),
    Int10  = (P'0' + R'19' * R'09'^0) / tonumber,
    Int16  = (P'$' + P'0' * S'xX') * expect(R('af', 'AF', '09')^1 / function(n) return tonumber('0x'..n) end, '不合法的16进制整数'),
    Int256 = "'" * expect((V'C4' + V'C1') * "'", '256进制整数必须是由1个或者4个字符组成'),
    C4     = V'C4W' * V'C4W' * V'C4W' * V'C4W' / function(n) return ('>I4'):unpack(n) end,
    C4W    = expect(1-P"'"-P'\\', '\\' * P(1), '4个字符组成的256进制整数不能使用转义字符'),
    C1     = ('\\' * expect(V'Esc', P(1), '不合法的转义字符') + C(1-P"'")) / function(n) return ('I1'):unpack(n) end,
    Esc    = P'b' / function() return '\b' end 
           + P't' / function() return '\t' end
           + P'r' / function() return '\r' end
           + P'n' / function() return '\n' end
           + P'f' / function() return '\f' end
           + P'"' / function() return '\"' end
           + P'\\' / function() return '\\' end,
}

local Value = sp * (Null + Bool + Str + Real + Int) * sp

local exp = P{
    'exp',
    
    -- 由低优先级向高优先级递归
    exp      = V'op_or',
    sub_exp  = V'paren' + V'func' + V'call' + Value + V'vari' + V'var' + V'neg',

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
    func  = Ct(keyvalue('type', 'function') * sp * 'function' * sps * Cg(id, 'name') * sp),
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
        * (sp * '=' * Cg(exp) + P(true)))
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

local pjass = (ign + global)^0 * (ign + typedef + func)^0 + err'语法不正确'

local mt = {}
setmetatable(mt, mt)

mt.err    = err
mt.spl    = spl
mt.ign    = ign
mt.Value   = Value
mt.id     = id
mt.exp    = exp
mt.global = global
mt.loc    = loc
mt.line   = line
mt.logic  = logic
mt.func   = func
mt.pjass  = pjass

function mt:__call(_jass, mode)
    jass = _jass
    line_count = 1
    line_pos = 1
    lpeg.setmaxstack(1000)
    
    if mode then
        return Ct((mt[mode] + spl)^1 + err'语法不正确'):match(_jass)
    else
        return Ct(pjass):match(_jass)
    end
end

return mt
