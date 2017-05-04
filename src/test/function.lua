check[[
function test takes nothing returns nothing
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
}

check[[
function test takes nothing returns boolean
endfunction
]]
{
    type = 'function',
    name = 'test',
    returns = 'boolean',
    locals = {},
}

check[[
function test takes integer i returns nothing
endfunction
]]
{
    type = 'function',
    name = 'test',
    args = {
        [1] = {
            type = 'integer',
            name = 'i',
        },
    },
    locals = {},
}

check[[
function test takes integer i, boolean b, unit u returns nothing
endfunction
]]
{
    type = 'function',
    name = 'test',
    args = {
        [1] = {
            type = 'integer',
            name = 'i',
        },
        [2] = {
            type = 'boolean',
            name = 'b',
        },
        [3] = {
            type = 'unit',
            name = 'u',
        },
    },
    locals = {},
}

check[[
function test takes nothing returns nothing
    local unit u
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {
        [1] = {
            type = 'unit',
            name = 'u',
            line = 2,
        },
    },
}


check[[
function test takes nothing returns nothing
    local integer array i
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {
        [1] = {
            type = 'integer',
            name = 'i',
            array = true,
            line = 2,
        },
    },
}

check[[
function test takes nothing returns nothing
    local integer i = 0
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {
        [1] = {
            type = 'integer',
            name = 'i',
            line = 2,
            [1] = {
                type = 'integer',
                value = 0,
            },
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
    type = 'function',
    name = 'test',
    locals = {
        [1] = {
            type = 'integer',
            name = 'i',
            line = 2,
        },
        [2] = {
            type = 'unit',
            name = 'u',
            line = 3,
        },
        [3] = {
            type = 'boolean',
            name = 'ab',
            array = true,
            line = 4,
        },
        [4] = {
            type = 'integer',
            name = 'x',
            line = 5,
            [1] = {
                type = 'integer',
                value = 0,
            },
        },
    },
}

check[[
function test takes nothing returns nothing
    call test()
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'call',
        name = 'test',
    },
}

check[[
function test takes nothing returns nothing
    call test(1, 2, 3)
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'call',
        name = 'test',
        [1] = {
            type = 'integer',
            value = 1,
        },
        [2] = {
            type = 'integer',
            value = 2,
        },
        [3] = {
            type = 'integer',
            value = 3,
        },
    },
}

check[[
function test takes nothing returns nothing
    set x = 1
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'set',
        name = 'x',
        [1] = {
            type = 'integer',
            value = 1,
        },
    },
}

check[[
function test takes nothing returns nothing
    set x[5] = 1
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'seti',
        name = 'x',
        [1] = {
            type = 'integer',
            value = 5,
        },
        [2] = {
            type = 'integer',
            value = 1,
        },
    },
}

check[[
function test takes nothing returns nothing
    return
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'return',
    },
}

check[[
function test takes nothing returns nothing
    return 0
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'return',
        [1] = {
            type = 'integer',
            value = 0,
        },
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
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'call',
        name = 'test',
    },
    [2] = {
        type = 'seti',
        name = 'x',
        [1] = {
            type = 'integer',
            value = 5,
        },
        [2] = {
            type = 'integer',
            value = 1,
        }
    },
    [3] = {
        type = 'return',
        [1] = {
            type = 'integer',
            value = 0,
        },
    },
}
