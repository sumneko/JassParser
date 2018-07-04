local function test(name)
    local clock = os.clock()
    print(('测试[%s]...'):format(name))
    require('test.' .. name)
    print(('测试[%s]用时[%.3f]'):format(name, os.clock() - clock))
end

test 'unit_test'
test 'grammar'
--test 'fail'

print('测试完成')
