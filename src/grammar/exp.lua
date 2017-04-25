check[[
function test takes nothing returns nothing
    return 0
endfunction
]]
{
    ['类型'] = '函数',
    ['名称'] = 'test',
    ['无参数'] = true,
    ['无返回值'] = true,
    ['局部变量'] = {},
    [1] = {
        ['类型'] = '返回',
        ['返回值'] = {
            ['类型'] = '值',
            ['值'] = IGNORE,
        },
    },
}

check[[
function test takes nothing returns nothing
    return test()
endfunction
]]
{
    ['类型'] = '函数',
    ['名称'] = 'test',
    ['无参数'] = true,
    ['无返回值'] = true,
    ['局部变量'] = {},
    [1] = {
        ['类型'] = '返回',
        ['返回值'] = {
            ['类型'] = '函数调用',
            ['名称'] = 'test',
            ['参数'] = {},
        },
    },
}

check[[
function test takes nothing returns nothing
    return test(x, y, z)
endfunction
]]
{
    ['类型'] = '函数',
    ['名称'] = 'test',
    ['无参数'] = true,
    ['无返回值'] = true,
    ['局部变量'] = {},
    [1] = {
        ['类型'] = '返回',
        ['返回值'] = {
            ['类型'] = '函数调用',
            ['名称'] = 'test',
            ['参数'] = {
                [1] = {
                    ['类型'] = '变量',
                    ['名称'] = 'x',
                },
                [2] = {
                    ['类型'] = '变量',
                    ['名称'] = 'y',
                },
                [3] = {
                    ['类型'] = '变量',
                    ['名称'] = 'z',
                },
            },
        },
    },
}

check[[
function test takes nothing returns nothing
    return function test
endfunction
]]
{
    ['类型'] = '函数',
    ['名称'] = 'test',
    ['无参数'] = true,
    ['无返回值'] = true,
    ['局部变量'] = {},
    [1] = {
        ['类型'] = '返回',
        ['返回值'] = {
            ['类型'] = '函数对象',
            ['名称'] = 'test',
        },
    },
}

check[[
function test takes nothing returns nothing
    return function test
endfunction
]]
{
    ['类型'] = '函数',
    ['名称'] = 'test',
    ['无参数'] = true,
    ['无返回值'] = true,
    ['局部变量'] = {},
    [1] = {
        ['类型'] = '返回',
        ['返回值'] = {
            ['类型'] = '函数对象',
            ['名称'] = 'test',
        },
    },
}

check[[
function test takes nothing returns nothing
    return i
endfunction
]]
{
    ['类型'] = '函数',
    ['名称'] = 'test',
    ['无参数'] = true,
    ['无返回值'] = true,
    ['局部变量'] = {},
    [1] = {
        ['类型'] = '返回',
        ['返回值'] = {
            ['类型'] = '变量',
            ['名称'] = 'i',
        },
    },
}

check[[
function test takes nothing returns nothing
    return i[x]
endfunction
]]
{
    ['类型'] = '函数',
    ['名称'] = 'test',
    ['无参数'] = true,
    ['无返回值'] = true,
    ['局部变量'] = {},
    [1] = {
        ['类型'] = '返回',
        ['返回值'] = {
            ['类型'] = '变量',
            ['名称'] = 'i',
            ['索引'] = {
                ['类型'] = '变量',
                ['名称'] = 'x',
            },
        },
    },
}

check[[
function test takes nothing returns nothing
    return (x)
endfunction
]]
{
    ['类型'] = '函数',
    ['名称'] = 'test',
    ['无参数'] = true,
    ['无返回值'] = true,
    ['局部变量'] = {},
    [1] = {
        ['类型'] = '返回',
        ['返回值'] = {
            ['类型'] = '括号',
            ['表达式'] = {
                ['类型'] = '变量',
                ['名称'] = 'x',
            },
        },
    },
}

check[[
function test takes nothing returns nothing
    return ((x))
endfunction
]]
{
    ['类型'] = '函数',
    ['名称'] = 'test',
    ['无参数'] = true,
    ['无返回值'] = true,
    ['局部变量'] = {},
    [1] = {
        ['类型'] = '返回',
        ['返回值'] = {
            ['类型'] = '括号',
            ['表达式'] = {
                ['类型'] = '括号',
                ['表达式'] = {
                    ['类型'] = '变量',
                    ['名称'] = 'x',
                },
            },
        },
    },
}

check[[
function test takes nothing returns nothing
    return not x
endfunction
]]
{
    ['类型'] = '函数',
    ['名称'] = 'test',
    ['无参数'] = true,
    ['无返回值'] = true,
    ['局部变量'] = {},
    [1] = {
        ['类型'] = '返回',
        ['返回值'] = {
            ['类型'] = '非',
            ['符号'] = 'not',
            ['表达式'] = {
                ['类型'] = '变量',
                ['名称'] = 'x',
            },
        },
    },
}

check[[
function test takes nothing returns nothing
    return not (x)
endfunction
]]
{
    ['类型'] = '函数',
    ['名称'] = 'test',
    ['无参数'] = true,
    ['无返回值'] = true,
    ['局部变量'] = {},
    [1] = {
        ['类型'] = '返回',
        ['返回值'] = {
            ['类型'] = '非',
            ['符号'] = 'not',
            ['表达式'] = {
                ['类型'] = '括号',
                ['表达式'] = {
                    ['类型'] = '变量',
                    ['名称'] = 'x',
                },
            },
        },
    },
}

check[[
function test takes nothing returns nothing
    return not not x
endfunction
]]
{
    ['类型'] = '函数',
    ['名称'] = 'test',
    ['无参数'] = true,
    ['无返回值'] = true,
    ['局部变量'] = {},
    [1] = {
        ['类型'] = '返回',
        ['返回值'] = {
            ['类型'] = '非',
            ['符号'] = 'not',
            ['表达式'] = {
                ['类型'] = '非',
                ['符号'] = 'not',
                ['表达式'] = {
                    ['类型'] = '变量',
                    ['名称'] = 'x',
                },
            },
        },
    },
}
