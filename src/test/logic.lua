check[[
function test takes nothing returns nothing
    if a then
    endif
endfunction
]]
{
    ['类型'] = '函数',
    ['名称'] = 'test',
    ['无参数'] = true,
    ['无返回值'] = true,
    ['局部变量'] = {},
    [1] = {
        ['类型'] = '判断',
        [1] = {
            ['条件'] = IGNORE,
        },
    },
}

check[[
function test takes nothing returns nothing
    if a then
        call test()
    endif
endfunction
]]
{
    ['类型'] = '函数',
    ['名称'] = 'test',
    ['无参数'] = true,
    ['无返回值'] = true,
    ['局部变量'] = {},
    [1] = {
        ['类型'] = '判断',
        [1] = {
            ['条件'] = IGNORE,
            [1] = {
                ['类型'] = '函数调用',
                ['函数'] = IGNORE,
            },
        },
    },
}

check[[
function test takes nothing returns nothing
    if a then
        set x = 1
    elseif b then
        set y = 1
    elseif c then
        set z = 1
    else
        set w = 1
    endif
endfunction
]]
{
    ['类型'] = '函数',
    ['名称'] = 'test',
    ['无参数'] = true,
    ['无返回值'] = true,
    ['局部变量'] = {},
    [1] = {
        ['类型'] = '判断',
        [1] = {
            ['条件'] = IGNORE,
            [1] = {
                ['类型'] = '设置变量',
                ['名称'] = 'x',
                ['值'] = IGNORE,
            },
        },
        [2] = {
            ['条件'] = IGNORE,
            [1] = {
                ['类型'] = '设置变量',
                ['名称'] = 'y',
                ['值'] = IGNORE,
            },
        },
        [3] = {
            ['条件'] = IGNORE,
            [1] = {
                ['类型'] = '设置变量',
                ['名称'] = 'z',
                ['值'] = IGNORE,
            },
        },
        [4] = {
            ['无条件'] = true,
            [1] = {
                ['类型'] = '设置变量',
                ['名称'] = 'w',
                ['值'] = IGNORE,
            },
        },
    },
}

check[[
function test takes nothing returns nothing
    loop
    endloop
endfunction
]]
{
    ['类型'] = '函数',
    ['名称'] = 'test',
    ['无参数'] = true,
    ['无返回值'] = true,
    ['局部变量'] = {},
    [1] = {
        ['类型'] = '循环',
    },
}

check[[
function test takes nothing returns nothing
    loop
        exitwhen true
    endloop
endfunction
]]
{
    ['类型'] = '函数',
    ['名称'] = 'test',
    ['无参数'] = true,
    ['无返回值'] = true,
    ['局部变量'] = {},
    [1] = {
        ['类型'] = '循环',
        [1] = {
            ['类型'] = '退出循环',
            ['条件'] = IGNORE,
        },
    },
}

check[[
function test takes nothing returns nothing
    loop
        if a then
            exitwhen true
        endif
    endloop
endfunction
]]
{
    ['类型'] = '函数',
    ['名称'] = 'test',
    ['无参数'] = true,
    ['无返回值'] = true,
    ['局部变量'] = {},
    [1] = {
        ['类型'] = '循环',
        [1] = {
            ['类型'] = '判断',
            [1] = {
                ['条件'] = IGNORE,
                [1] = {
                    ['类型'] = '退出循环',
                    ['条件'] = IGNORE,
                },
            },
        },
    },
}

