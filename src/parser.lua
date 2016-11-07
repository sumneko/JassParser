local line_count = 1

local sp   = S' \t'^0
local sps  = S' \t'^1
local nl1  = P'\r\n' + S'\r\n'
local com  = P'//' * (1-nl1)^0
local nl   = com^0 * nl1 / function() line_count = line_count + 1 end
local quo  = P'"'
local esc  = P'\\'
local op1  = S'+-*/'
local op2  = P'-'
local op3  = S'><=!' * P'=' + S'><'
local int1 = (P'-' * sp)^-1 * (P'0' + R'19' * R'09'^0)
local int2 = P'$' * R('af', 'AF', '09')^1
local int3 = P'0' * S'xX' * R('af', 'AF', '09')^1
local int  = int2 + int3 + int1
local real = R'09'^0 * P'.' * R'09'^0
local bool = P'true' + P'false'
local str1 = esc * P(1) + (1-quo)
local str2 = str1 + nl
local str  = quo * str2^0 * quo
local id   = R('az', 'AZ') * R('az', 'AZ', '09', '__')^0

local exp1 = sp * (int + real + bool + str + id) * sp

local exp = P{
    'exp',
    exp   = V'bra' + V'op3' + V'op2' + V'op1' + V'call' + V'index' + exp1,
    exp1  = V'bra' + V'op2' + V'call' + V'index' + exp1,
    exp2  = V'bra' + V'op2' + V'op1' + V'call' + V'index' + exp1,
    bra   = sp * '(' * V'exp' * ')' * sp,
    op1   = V'exp1' * (op1 * V'exp1')^0,
    op2   = sp * op2 * V'exp',
    op3   = V'exp2' * op3 * V'exp2',
    args  = V'exp' * (',' * sp * V'exp')^0 + sp,
    call  = exp1 * '(' * V'args' * ')' * sp,
    index = exp1 * '[' * V'exp' * ']' * sp,
}

local func = P{
    'func',
    func = 'function' * sps * id * sps * 'takes' * sps * V'args' * sps * 'returns' * sps * id * sp * nl * V'content' * sp * 'endfunction',
    args = 'nothing' + id * sps * id * (sp * ',' * sp * id * sps * id)^0,
    call = 'call' * sps * id * sp * '(' * exp * ')',
    set  = 'set' * sps * id * sp * '=' * exp,
    line = sp * (V'call' + V'set' + sp) * sp * nl,
    content = V'line'^0,
}

local global = P{
    'global',
    global = 'globals' * sp * nl * V'val'^0 * sp * 'endglobals',
    val    = sp * (V'const' + V'array' + V'set' + V'def' + sp) * sp * nl,
    def    = id * sps * id,
    set    = V'def' * sp * '=' * sp * exp,
    const  = 'constant' * sps * V'set',
    array  = id * sps * 'array' * sps * id,
}

local err  = P(1) / function(c) error(('line[%d]: 错误的字符: "%s"'):format(line_count, c)) end

return function (jass)
    local anyword = sps + nl + C(func + global) + err
    local words = Ct(anyword^1):match(jass)
    print(line_count, words[#words])
    print('用时', os.clock())
end

--[[
op1 <=
value <=
op <=
exp <= (exp)|exp op exp|value|op1 exp
id <= [A-Za-z][A-Za-z_0-9]*
type <= id
localdef <= local type id (= exp)?
]]