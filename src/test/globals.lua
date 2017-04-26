check[[
globals
endglobals
]]
{
    ['类型'] = '全局变量',
}

check[[
globals
    integer i
endglobals
]]
{
    ['类型'] = '全局变量',
    [1] = {
        ['名称'] = 'i',
        ['类型'] = 'integer',
    },
}

check[[
globals
    boolean array b
endglobals
]]
{
    ['类型'] = '全局变量',
    [1] = {
        ['名称'] = 'b',
        ['类型'] = 'boolean',
        ['数组'] = true,
    },
}

check[[
globals
    constant integer ci
endglobals
]]
{
    ['类型'] = '全局变量',
    [1] = {
        ['名称'] = 'ci',
        ['类型'] = 'integer',
        ['常量'] = true,
    },
}

check[[
globals
    constant boolean array b
endglobals
]]
{
    ['类型'] = '全局变量',
    [1] = {
        ['名称'] = 'b',
        ['类型'] = 'boolean',
        ['数组'] = true,
        ['常量'] = true,
    },
}

check[[
globals
    integer i = 0
endglobals
]]
{
    ['类型'] = '全局变量',
    [1] = {
        ['名称'] = 'i',
        ['类型'] = 'integer',
        ['初始值'] = IGNORE,
    },
}

check[[
globals
    constant integer i = 0
endglobals
]]
{
    ['类型'] = '全局变量',
    [1] = {
        ['名称'] = 'i',
        ['类型'] = 'integer',
        ['常量'] = true,
        ['初始值'] = IGNORE,
    },
}

check[[
globals
    integer i
    boolean b
    integer array ai
    constant boolean cb
endglobals
]]
{
    ['类型'] = '全局变量',
    [1] = {
        ['名称'] = 'i',
        ['类型'] = 'integer',
    },
    [2] = {
        ['名称'] = 'b',
        ['类型'] = 'boolean',
    },
    [3] = {
        ['名称'] = 'ai',
        ['类型'] = 'integer',
        ['数组'] = true,
    },
    [4] = {
        ['名称'] = 'cb',
        ['类型'] = 'boolean',
        ['常量'] = true
    },
}
