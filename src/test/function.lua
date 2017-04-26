check[[
function test takes nothing returns nothing
endfunction
]]
{
    ['类型'] = '函数',
    ['名称'] = 'test',
    ['无参数'] = true,
    ['无返回值'] = true,
    ['局部变量'] = {},
}

check[[
function test takes nothing returns boolean
endfunction
]]
{
    ['类型'] = '函数',
    ['名称'] = 'test',
    ['无参数'] = true,
    ['返回值类型'] = 'boolean',
    ['局部变量'] = {},
}

check[[
function test takes integer i returns nothing
endfunction
]]
{
    ['类型'] = '函数',
    ['名称'] = 'test',
    ['参数'] = {
        [1] = {
            ['类型'] = 'integer',
            ['名称'] = 'i',
        },
    },
    ['无返回值'] = true,
    ['局部变量'] = {},
}

check[[
function test takes integer i, boolean b, unit u returns nothing
endfunction
]]
{
    ['类型'] = '函数',
    ['名称'] = 'test',
    ['参数'] = {
        [1] = {
            ['类型'] = 'integer',
            ['名称'] = 'i',
        },
        [2] = {
            ['类型'] = 'boolean',
            ['名称'] = 'b',
        },
        [3] = {
            ['类型'] = 'unit',
            ['名称'] = 'u',
        },
    },
    ['无返回值'] = true,
    ['局部变量'] = {},
}

check[[
function test takes nothing returns nothing
    local unit u
endfunction
]]
{
    ['类型'] = '函数',
    ['名称'] = 'test',
    ['无参数'] = true,
    ['无返回值'] = true,
    ['局部变量'] = {
        [1] = {
            ['类型'] = 'unit',
            ['名称'] = 'u',
        },
    },
}


check[[
function test takes nothing returns nothing
    local integer array i
endfunction
]]
{
    ['类型'] = '函数',
    ['名称'] = 'test',
    ['无参数'] = true,
    ['无返回值'] = true,
    ['局部变量'] = {
        [1] = {
            ['类型'] = 'integer',
            ['名称'] = 'i',
            ['数组'] = true,
        },
    },
}

check[[
function test takes nothing returns nothing
    local integer i = 0
endfunction
]]
{
    ['类型'] = '函数',
    ['名称'] = 'test',
    ['无参数'] = true,
    ['无返回值'] = true,
    ['局部变量'] = {
        [1] = {
            ['类型'] = 'integer',
            ['名称'] = 'i',
            ['初始值'] = IGNORE,
        },
    },
}


check[[
function test takes nothing returns nothing
    local integer i
    local unit u
    local boolean array ab
    local integer x = 0
endfunction
]]
{
    ['类型'] = '函数',
    ['名称'] = 'test',
    ['无参数'] = true,
    ['无返回值'] = true,
    ['局部变量'] = {
        [1] = {
            ['类型'] = 'integer',
            ['名称'] = 'i',
        },
        [2] = {
            ['类型'] = 'unit',
            ['名称'] = 'u',
        },
        [3] = {
            ['类型'] = 'boolean',
            ['名称'] = 'ab',
            ['数组'] = true,
        },
        [4] = {
            ['类型'] = 'integer',
            ['名称'] = 'x',
            ['初始值'] = IGNORE,
        },
    },
}

check[[
function test takes nothing returns nothing
    call test()
endfunction
]]
{
    ['类型'] = '函数',
    ['名称'] = 'test',
    ['无参数'] = true,
    ['无返回值'] = true,
    ['局部变量'] = {},
    [1] = {
        ['类型'] = '函数调用',
        ['函数'] = IGNORE,
    },
}

check[[
function test takes nothing returns nothing
    set x = 1
endfunction
]]
{
    ['类型'] = '函数',
    ['名称'] = 'test',
    ['无参数'] = true,
    ['无返回值'] = true,
    ['局部变量'] = {},
    [1] = {
        ['类型'] = '设置变量',
        ['名称'] = 'x',
        ['值'] = IGNORE,
    },
}

check[[
function test takes nothing returns nothing
    set x[5] = 1
endfunction
]]
{
    ['类型'] = '函数',
    ['名称'] = 'test',
    ['无参数'] = true,
    ['无返回值'] = true,
    ['局部变量'] = {},
    [1] = {
        ['类型'] = '设置变量',
        ['名称'] = 'x',
        ['索引'] = IGNORE,
        ['值'] = IGNORE,
    },
}

check[[
function test takes nothing returns nothing
    return
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
        ['无返回值'] = true,
    },
}

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
        ['返回值'] = IGNORE,
    },
}

check[[
function test takes nothing returns nothing
    call test()
    set x[5] = 1
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
        ['类型'] = '函数调用',
        ['函数'] = IGNORE,
    },
    [2] = {
        ['类型'] = '设置变量',
        ['名称'] = 'x',
        ['索引'] = IGNORE,
        ['值'] = IGNORE,
    },
    [3] = {
        ['类型'] = '返回',
        ['返回值'] = IGNORE,
    },
}
