local parser = require 'parser'

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

local word = parser.word + parser.err'单词测试失败'
for _, str in ipairs(word_list) do
    word:match(str)
end

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
'1==2 and 3!=4 or true',
'test(),',
'test(1)',
'test(1, 2, 3)',
'(1!=2)',
'unit[1]',
'unit[1+2]',
'test(unit[1], unit[1+2], (1+2), unit[test(1, 2)], 2)',
}

local exp = parser.exp + parser.err'表达式测试失败'
for _, str in ipairs(exp_list) do
    exp:match(str)
end

print('单元测试完成,用时', os.clock(), '秒')
