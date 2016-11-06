local str_line_count = 0
local line_count = 1

local sp   = S' \t'^1
local nl1  = P'\r\n' + S'\r\n'
local nl   = nl1 / function() line_count = line_count + 1 end
local com  = P'//' * (1-nl)^0
local quo  = P'"'
local esc  = P'\\'
local op1  = S'+-*/=<>' + (S'><=!' * P'=')
local op2  = P'-'
local op   = op1 + op2
local int1 = P'0' + R'19' * R'09'^0
local int2 = P'$' * R('af', 'AF', '09')^1
local int3 = P'0' * S'xX' * R('af', 'AF', '09')^1
local int  = int1 + int2 + int3
local real = R'09'^0 * P'.' * R'09'^0
local bool = P'true' + P'false'
local str1 = esc * P(1) + (1-quo)
local str2 = str1 + nl1 / function () str_line_count = str_line_count + 1 end
local str  = (quo * str2^0 * quo) / function() line_count = line_count + str_line_count ; str_line_count = 0 end
local id   = R('az', 'AZ') * R('az', 'AZ', '09', '__')^0

local exp1 = sp^0 * (int + real + bool + str + id) * sp^0
local exp2 = sp^0 * P'(' * exp1 * P')' * sp^0 + exp1
--local exp3 = sp^0 * op2 * exp2 + exp2 * op1 * exp2 + exp2
--local exp4 = exp3 * P'(' * exp3 * P')' + exp3 * P'[' * exp3 * ']' + exp3
local exp  = exp2

local err  = P(1) / function(c) error(('line[%d]: 错误的字符: "%s"'):format(line_count, c)) end

return function (jass)
    local anyword = sp + nl + com + C(exp + op + int + real + bool + str + id) + err
    local words = Ct(anyword ^ 1):match(jass)
    print(line_count, words[#words])
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