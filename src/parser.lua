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
    exp      = C(V'op_or'),
    sub_exp  = V'bra' + V'func' + V'call' + V'index' + Cg(word, '变量'),

    -- 由于不消耗字符串,只允许向下递归
    op_or    = Cg(V'op_and', '表达式1') * (keyvalue('类型', '或') * Cg(op_or, '符号') * expect(Cg(V'op_and', '表达式2'), '符号"or"错误'))^0,
    op_and   = Cg(V'op_rel', '表达式1') * (keyvalue('类型', '与') * Cg(op_and, '符号') * expect(Cg(V'op_rel', '表达式2'), '符号"and"错误'))^0,
    op_rel   = Cg(V'op_add', '表达式1') * (keyvalue('类型', '判断') * Cg(op_rel, '符号') * expect(Cg(V'op_add', '表达式2'), '逻辑判断符错误'))^-1,
    op_add   = Cg(V'op_mul', '表达式1') * (keyvalue('类型', '加法') * Cg(op_add, '符号') * expect(Cg(V'op_mul', '表达式2'), '符号"+-"错误'))^0,
    op_mul   = Cg(V'op_not', '表达式1') * (keyvalue('类型', '乘法') * Cg(op_mul, '符号') * expect(Cg(V'op_not', '表达式2'), '符号"*/"错误'))^0,

    -- 由于消耗了字符串,可以递归回顶层
    op_not   = keyvalue('类型', '非') * sp * Cg(op_not, '符号') * expect(Cg(V'sub_exp', '表达式1'), '符号"not"错误') + sp * V'sub_exp',

    -- 由于消耗了字符串,可以递归回顶层
    bra   = keyvalue('类型', '括号') * sp * br1 * expect(Cg(V'exp', '内容'), '括号内的表达式错误') * br2 * sp,
    call  = keyvalue('类型', '函数调用') * Cg(word, '名称') * br1 * expect(Cg(V'args', '参数'), '函数的参数不正确'),
    args  = Ct(sp * br2 * sp + expect(V'exp', '函数的参数1不正确') * V'narg'),
    narg  = sp * br2 * sp + expect(P',', '后续参数要用","分割') * expect(V'exp', '函数的后续参数不正确') * V'narg',
    index = Cg(word, '变量') * ix1 * expect(Cg(V'exp', '索引'), '索引表达式不正确') * ix2 * sp,
    func  = sp * 'function' * keyvalue('类型', '函数对象') * sps * Cg(id, '名称') * sp,
}

local typedef = P{
    'def',
    def  = sp * 'type' * expect(sps * Cg(id, '名称'), '变量类型定义错误') * expect(V'ext', '变量类型继承错误') * keyvalue('类型', '类型定义') / Ct,
    ext  = sps * 'extends' * sps * Cg(id, '继承'),
}

local global = P{
    'global',
    global = Ct(sp * 'globals' * spl * expect(Cg(V'vals', '定义'), '全局变量未知错误') * keyvalue('类型', '全局变量') * expect('endglobals', '缺少endglobals')),
    vals   = Ct((spl + V'def')^0),
    def    = Ct(sp
        * ('constant' * sps * keyvalue('常量', true) + P(true))
        * Cg(id, '类型') * sps
        * ('array' * sps * keyvalue('数组', true) + P(true))
        * Cg(id, '名称')
        * (sp * '=' * expect(Cg(exp, '初始值')) + P(true)))
        ,
}

local loc = P{
    'loc',
    loc = Ct(sp * 'local' * expect(sps * V'val', '局部变量声明错误')),
    val    = V'array' + V'set' + V'def',
    def    = Cg(id, '类型') * sps * Cg(id, '名称'),
    set    = Cg(id, '类型') * sps * Cg(id, '名称') * sp * '=' * sp * expect(Cg(exp, '初始值'), '局部变量声明时赋值错误'),
    array  = Cg(id, '类型') * sps * 'array' * keyvalue('数组', true) * expect(sps * Cg(id, '名称'), '局部变量数组声明错误'),
}

local line = P{
    'line',
    line  = sp * ('call' * expect(V'call', 'call语法不正确') + 'set' * expect(V'set', 'set语法不正确') + 'return' * V'rtn'),
    call  = Ct(sps * keyvalue('类型', '函数调用') * expect(Cg(exp, '函数'), '函数调用表达式错误')),
    set   = Ct(sps * keyvalue('类型', '设置变量') * expect(V'val', '变量不正确') * '=' * expect(Cg(exp, '值'), '变量设置表达式错误')),
    rtn   = Ct(keyvalue('类型', '返回') * (sp * #(1-nl) * expect(Cg(exp, '返回值'), 'return语法不正确') + keyvalue('无返回值', true))),
    val   = sp * Cg(id, '名称') * sp * '[' * expect(Cg(exp, '索引'), '数组索引表达式错误') * ']' * sp + sp * Cg(id, '名称') * sp,
}

local logic = P{
    'logic',
    logic    = V'iif' + V'lloop',

    iif      = Ct(sp * 'if' * keyvalue('类型', '判断') * Cg(V'ichunk', '代码块') * V'iendif'),
    ichunk   = Ct(V'ifif' * V'ielseif'^0 * V'ielse'^-1),
    ifif     = Ct(V'ihead' * Cg(V'icontent', '内容')),
    ihead    = nid * Cg(exp, '条件') * expect(V'ithen', 'if后面没有then'),
    ithen    = sp * 'then' * spl,
    icontent = Ct((spl + V'logic' + V'lexit' + line)^0),
    ielseif  = Ct(sp * 'elseif' * V'ihead' * Cg(V'icontent', '内容')),
    ielse    = Ct(sp * 'else' * spl * Cg(V'icontent', '内容')),
    iendif   = sp * 'endif' * spl,

    lloop    = Ct(V'lhead' * keyvalue('类型', '循环') * Cg(V'lcontent', '内容') * V'lendloop'),
    lhead    = sp * 'loop' * spl,
    lcontent = Ct((spl + V'logic' + V'lexit' + line)^0),
    lexit    = Ct(sp * 'exitwhen' * keyvalue('类型', '退出循环') * expect(sps * Cg(exp, '条件'), 'exitwhen表达式错误') * spl),
    lendloop = sp * 'endloop' * spl,
}

local func = P{
    'fct',
    fct      = Ct((V'native' + V'func') * keyvalue('类型', '函数')),
    native   = sp * (P'constant' * keyvalue('常量', true))^-1 * sp * 'native' * keyvalue('本地函数', true) * expect(V'fhead', 'native函数未知错误'),
    func     = sp * 'function' * expect(V'fhead', '函数声明格式不正确') * expect(V'fcontent', '函数主体不正确') * expect(V'fend', '缺少endfunction'),
    fhead    = sps * expect(V'fname', '函数名称不正确') * expect(V'fargs', '函数的参数声明不正确') * expect(V'freturns', '函数的返回格式不正确'),
    fname    = sp * Cg(id, '名称') * sp,
    fargs    = sp * 'takes' * sps * (V'anull' * keyvalue('无参数', true) + Cg(V'anarg', '参数')),
    arg      = Ct(sp * Cg(id, '类型') * sps * Cg(id, '名称') * sp),
    anull    = sp * 'nothing' * sp,
    anarg    = Ct(sp * V'arg' * (',' * V'arg')^0),
    freturns = sp * 'returns' * sps * ('nothing' * keyvalue('无返回值', true) + Cg(id, '返回值类型')) * spl,
    fcontent = sp * expect(Cg(V'flocal', '局部变量'), '函数局部变量区域不正确') * expect(Cg(V'flines', '语句'), '函数代码区域不正确'),
    flocal   = Ct((spl + loc)^0),
    flines   = Ct((spl + logic + line)^0),
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
    lpeg.line_count = 1
    lpeg.setmaxstack(1000)
    local t = Ct(pjass):match(jass)
    return t
end

return mt
