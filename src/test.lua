local lpeg = require 'lpeg'
local parser = require 'parser'
local C = lpeg.C

local function check(list, mode)
    for _, str in ipairs(list) do
        if C(parser[mode]):match(str) ~= str then
            error(mode .. '测试失败:\n' .. ('='):rep(30) .. '\n' .. str .. '\n' .. ('='):rep(30))
        end
    end
end

local word_list = {
'1',
'-1',
'- 1',
'0',
'55',
'$012345ad',
'$012345AD',
'0X012345AD',
'0xafBD12cE',
'12.34',
'-12.34',
'.34',
'-.34',
'12.',
'-12.',
'- 2',
'- 1.2',
'true',
'false',
'test',
'a12_szSFS___S0',
'""',
'"测试"',
[["测试\""]],
[["测试\\"]],
[["测试
测试"]],
}

check(word_list, 'word')

local exp_list = {
'(test)',
'((test))',
'1+2',
'1*2',
'1+2+3',
'2*(3+4)',
'1 == 2',
'1 +2> 4',
'2!=4',
'1+2*3==2*3+4',
'1==2 and 3!=4',
'test()',
'test(1)',
'test(1, 2, 3)',
'(1!=2)',
'unit[1]',
'unit[1+2]',
'test(unit[1], unit[1+2], (1+2), unit[test(1, 2)], 2)',
'chance == 0 or GetUnitTypeId(u) == 0',
}

check(exp_list, 'exp')

local line_list = {
'call test(u)\n',
'set a = 1\n',
'set a[5] = 1\n',
'return\n',
'return 0\n',
}

check(line_list, 'line')

local logic_list = {
[[
if a then
    set a = 1 + 1
elseif b then
    call u(v)
else
    if c then
    endif
endif
]],
[[
loop
    exitwhen i > 10
    if a then
        loop
            if b then
            endif
        endloop
    endif
endloop
]]
}

check(logic_list, 'logic')

print('单元测试完成,用时', os.clock(), '秒')
