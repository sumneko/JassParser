local function test(name)
    local clock = os.clock()
    print(('测试[%s]...'):format(name))
    require(name)
    print(('测试[%s]用时[%.3f]'):format(name, os.clock() - clock))
end

test 'grammar'
test 'ast'
test 'should-check'
test 'should-fail'

print('测试完成')
