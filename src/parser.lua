local sp   = S' \t'^1
local nl   = P'\r\n' + S'\r\n'
local op1  = S'+-*/=<>' + (S'><=!' * P'=')
local op2  = P'-'
local op   = op1 + op2
local int1 = P'0' + R'19' * R'09'^0
local int2 = P'$' * R('af', 'AF', '09')^1
local int3 = P'0' * S'xX' * R('af', 'AF', '09')^1
local int  = int1 + int2 + int3
local real = R'09'^0 * P'.' * R'09'^0
local bool = P'true' + P'false'
local id   = R('az', 'AZ') * R('az', 'AZ', '09', '__')^0

return function (jass)
    local anyword = sp + nl + C(op + int + real + bool + id)
    local words = Ct(anyword ^ 1):match(jass)
    for k, v in pairs(words) do
        print(k, v)
    end
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