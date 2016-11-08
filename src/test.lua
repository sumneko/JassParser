local parser = require 'parser'

local exp_list = {
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
'"测试\"""',
'"测试\\"',
[["测试
测试"]],
'(test)',
'((test))',
}

for _, str in ipairs(exp_list) do
    parser.exp:match(str)
end

print('单元测试完成,用时', os.clock(), '秒')
