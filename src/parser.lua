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

local function errorpos(pos, str)
    local endpos = jass:find('[\r\n]', pos) or (#jass+1)
    local sp = (' '):rep(pos-line_pos)
    local line = ('%s|\r\n%s\r\n%s|'):format(sp, jass:sub(line_pos, endpos-1), sp)
    error(('第[%d]行: %s:\n===========================\n%s\n==========================='):format(line_count, str, line))
end

local function err(str)
    return Cp() / function(pos)
        errorpos(pos, str)
    end
end

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

local Keys = {'globals', 'endglobals', 'constant', 'native', 'array', 'and', 'or', 'not', 'type', 'extends', 'function', 'endfunction', 'nothing', 'takes', 'returns', 'call', 'set', 'return', 'if', 'endif', 'elseif', 'else', 'loop', 'endloop', 'exitwhen'}
for _, key in ipairs(Keys) do
    Keys[key] = true
end

local Id = P{
    'Def',
    Def  = C(V'Id') * Cp() / function(id, pos) if Keys[id] then errorpos(pos-#id, ('不能使用关键字[%s]作为函数名或变量名'):format(id)) end end,
    Id   = R('az', 'AZ') * R('az', 'AZ', '09', '__')^0,
}

local nl   = com^0 * nl1 * Cp() / function(p)
    line_count = line_count + 1
    line_pos = p
end
local spl  = sp * nl
local ign  = sps + nl
local nid  = #(1-Id)

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

local function currentline()
    return Cg(P(true) / function() return line_count end, 'line')
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
    Def   = Ct(keyvalue('type', 'boolean') * Cg(V'True' + V'False', 'value')),
    True  = P'true' * Cc(true),
    False = P'false' * Cc(false),
}
local Str = P{
    'Def',
    Def  = Ct(keyvalue('type', 'string') * Cg(V'Str', 'value')),
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
    Def  = Ct(keyvalue('type', 'real') * Cg(V'Real', 'value')),
    Real = V'Neg' * V'Char' / function(neg, n) return neg and -n or n end,
    Neg   = Cc(true) * P'-' * sp + Cc(false),
    Char  = (P'.' * expect(R'09'^1, '不合法的实数') + R'09'^1 * P'.' * R'09'^0) / tonumber,
}
local Int = P{
    'Def',
    Def    = Ct(keyvalue('type', 'integer') * Cg(V'Int', 'value')),
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
    call  = Ct(keyvalue('type', 'call') * sp * Cg(Id, 'name') * par1 * V'args' * par2 * sp),
    args  = V'exp' * (',' * V'exp')^0 + sp,
    vari  = Ct(keyvalue('type', 'vari') * sp * Cg(Id, 'name') * sp * ix1 * expect(Cg(V'exp', 1), '索引表达式不正确') * ix2 * sp),
    var   = Ct(keyvalue('type', 'var') * sp * Cg(Id, 'name') * sp),
    neg   = Ct(keyvalue('type', 'neg') * sp * neg * sp * Cg(V'sub_exp', 1)),
    func  = Ct(keyvalue('type', 'function') * sp * 'function' * sps * Cg(Id, 'name') * sp),
}

local Type = P{
    'Def',
    Def  = Ct(sp * 'type' * keyvalue('type', 'type') * currentline() * expect(sps * Cg(Id, 'name'), '变量类型定义错误') * expect(V'Ext', '类型继承错误')),
    Ext  = sps * 'extends' * sps * Cg(Id, 'extends'),
}

local Global = P{
    'Global',
    Global = Ct(sp * 'globals' * keyvalue('type', 'globals') * currentline() * V'Vals' * V'End'),
    Vals   = (spl + V'Def' * spl)^0,
    Def    = Ct(sp
        * currentline()
        * ('constant' * sps * keyvalue('constant', true) + P(true))
        * Cg(Id, 'type') * sps
        * ('array' * sps * keyvalue('array', true) + P(true))
        * Cg(Id, 'name')
        * (sp * '=' * Cg(exp) + P(true))
        ),
    End    = expect(sp * P'endglobals', '缺少endglobals'),
}

local Local = P{
    'Def',
    Def = Ct(sp
        * currentline()
        * 'local' * sps
        * Cg(Id, 'type') * sps
        * ('array' * sps * keyvalue('array', true) + P(true))
        * Cg(Id, 'name')
        * (sp * '=' * Cg(exp) + P(true))
        ),
}

local Line = P{
    'Def',
    Def    = sp * (V'Call' + V'Set' + V'Seti' + V'Return'),
    Call   = Ct(keyvalue('type', 'call') * currentline() * 'call' * sps * Cg(Id, 'name') * sp * '(' * V'Args' * ')' * sp),
    Args   = exp * (',' * exp)^0 + sp,
    Set    = Ct(keyvalue('type', 'set') * currentline() * 'set' * sps * Cg(Id, 'name') * sp * '=' * exp),
    Seti   = Ct(keyvalue('type', 'seti') * currentline() * 'set' * sps * Cg(Id, 'name') * sp * '[' * Cg(exp, 1) * ']' * sp * '=' * Cg(exp, 2)),
    Return = Ct(keyvalue('type', 'return') * currentline() * 'return' * (Cg(exp, 1) + P(true))),
}

local logic = P{
    'logic',
    logic    = V'iif' + V'lloop',

    iif      = Ct(sp * 'if' * keyvalue('type', 'if') * V'ichunk' * V'iendif'),
    ichunk   = V'ifif' * V'ielseif'^0 * V'ielse'^-1,
    ifif     = Ct(V'ihead' * V'icontent'),
    ihead    = nid * Cg(exp, 'condition') * expect(V'ithen', 'if后面没有then'),
    ithen    = sp * 'then' * spl,
    icontent = (spl + V'logic' + V'lexit' + Line)^0,
    ielseif  = Ct(sp * 'elseif' * V'ihead' * V'icontent'),
    ielse    = Ct(sp * 'else' * spl * V'icontent'),
    iendif   = sp * 'endif' * spl,

    lloop    = Ct(V'lhead' * keyvalue('type', 'loop') * V'lcontent' * V'lendloop'),
    lhead    = sp * 'loop' * spl,
    lcontent = (spl + V'logic' + V'lexit' + Line)^0,
    lexit    = Ct(sp * 'exitwhen' * keyvalue('type', 'exit') * expect(sps * Cg(exp, 1), 'exitwhen表达式错误') * spl),
    lendloop = sp * 'endloop' * spl,
}

local Function = P{
    'Def',
    Def      = Ct(keyvalue('type', 'function') * (V'Common' + V'Native')),
    Native   = sp * (P'constant' * keyvalue('constant', true) + P(true)) * sp * 'native' * keyvalue('native', true) * V'Head',
    Common   = sp * 'function' * V'Head' * V'Content' * V'End',
    Head     = sps * Cg(Id, 'name') * sps * 'takes' * sps * V'Takes' * sps * 'returns' * sps * V'Returns' * spl,
    Takes    = ('nothing' + Cg(V'Args', 'args')),
    Args     = Ct(sp * V'Arg' * (sp * ',' * sp * V'Arg')^0),
    Arg      = Ct(Cg(Id, 'type') * sps * Cg(Id, 'name')),
    Returns  = 'nothing' + Cg(Id, 'returns'),
    Content  = sp * Cg(V'Locals', 'locals') * V'Lines',
    Locals   = Ct((spl + Local)^0),
    Lines    = (spl + logic + Line)^0,
    End    = expect(sp * P'endfunction', '缺少endfunction'),
}

local pjass = expect(ign + Type + Function + Global, P(1), '语法不正确')^0

local mt = {}
setmetatable(mt, mt)

mt.err    = err
mt.spl    = spl
mt.ign    = ign
mt.Value  = Value
mt.Id     = Id
mt.exp    = exp
mt.Global = Global
mt.Local  = Local
mt.Line   = Line
mt.logic  = logic
mt.Function = Function
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
