check[[
native test takes nothing returns nothing
]]
{
    type = 'function',
    name = 'test',
    file = 'war3map.j',
    line = 1,
    native = true,
}

check[[
native test takes nothing returns nothing]]
{
    type = 'function',
    name = 'test',
    file = 'war3map.j',
    line = 1,
    native = true,
}

check[[
function test takes nothing returns nothing
endfunction
]]
{
    type = 'function',
    name = 'test',
    file = 'war3map.j',
    line = 1,
    endline = 2,
    locals = {},
}

check[[
function test takes nothing returns nothing
endfunction]]
{
    type = 'function',
    name = 'test',
    file = 'war3map.j',
    line = 1,
    endline = 2,
    locals = {},
}

check[[
function test takes nothing returns boolean
endfunction
]]
{
    type = 'function',
    name = 'test',
    file = 'war3map.j',
    line = 1,
    endline = 2,
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
    file = 'war3map.j',
    line = 1,
    endline = 2,
    args = {
        [1] = {
            type = 'integer',
            name = 'i',
        },
        i = {
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
    file = 'war3map.j',
    line = 1,
    endline = 2,
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
        i = {
            type = 'integer',
            name = 'i',
        },
        b = {
            type = 'boolean',
            name = 'b',
        },
        u = {
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
    file = 'war3map.j',
    line = 1,
    endline = 3,
    locals = {
        [1] = {
            type = 'unit',
            name = 'u',
            file = 'war3map.j',
            line = 2,
        },
        u = {
            type = 'unit',
            name = 'u',
            file = 'war3map.j',
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
    file = 'war3map.j',
    line = 1,
    endline = 3,
    locals = {
        [1] = {
            type = 'integer',
            name = 'i',
            array = true,
            file = 'war3map.j',
            line = 2,
        },
        i = {
            type = 'integer',
            name = 'i',
            array = true,
            file = 'war3map.j',
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
    file = 'war3map.j',
    line = 1,
    endline = 3,
    locals = {
        [1] = {
            type = 'integer',
            name = 'i',
            file = 'war3map.j',
            line = 2,
            [1] = {
                type = 'integer',
                value = 0,
                vtype = 'integer',
            },
        },
        i = {
            type = 'integer',
            name = 'i',
            file = 'war3map.j',
            line = 2,
            [1] = {
                type = 'integer',
                value = 0,
                vtype = 'integer',
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
    file = 'war3map.j',
    line = 1,
    endline = 6,
    locals = {
        [1] = {
            type = 'integer',
            name = 'i',
            file = 'war3map.j',
            line = 2,
        },
        [2] = {
            type = 'unit',
            name = 'u',
            file = 'war3map.j',
            line = 3,
        },
        [3] = {
            type = 'boolean',
            name = 'ab',
            array = true,
            file = 'war3map.j',
            line = 4,
        },
        [4] = {
            type = 'integer',
            name = 'x',
            file = 'war3map.j',
            line = 5,
            [1] = {
                type = 'integer',
                value = 0,
                vtype = 'integer',
            },
        },
        i = {
            type = 'integer',
            name = 'i',
            file = 'war3map.j',
            line = 2,
        },
        u = {
            type = 'unit',
            name = 'u',
            file = 'war3map.j',
            line = 3,
        },
        ab = {
            type = 'boolean',
            name = 'ab',
            array = true,
            file = 'war3map.j',
            line = 4,
        },
        x = {
            type = 'integer',
            name = 'x',
            file = 'war3map.j',
            line = 5,
            [1] = {
                type = 'integer',
                value = 0,
                vtype = 'integer',
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
    file = 'war3map.j',
    line = 1,
    endline = 3,
    locals = {},
    [1] = {
        type = 'call',
        name = 'test',
        file = 'war3map.j',
        line = 2,
    },
}

check[[
function test takes integer a, integer b, integer c returns nothing
    call test(1, 2, 3)
endfunction
]]
{
    type = 'function',
    name = 'test',
    file = 'war3map.j',
    line = 1,
    endline = 3,
    args = {
        [1] = {
            type = 'integer',
            name = 'a',
        },
        [2] = {
            type = 'integer',
            name = 'b',
        },
        [3] = {
            type = 'integer',
            name = 'c',
        },
        a = {
            type = 'integer',
            name = 'a',
        },
        b = {
            type = 'integer',
            name = 'b',
        },
        c = {
            type = 'integer',
            name = 'c',
        },
    },
    locals = {},
    [1] = {
        type = 'call',
        name = 'test',
        file = 'war3map.j',
        line = 2,
        [1] = {
            type = 'integer',
            value = 1,
            vtype = 'integer',
        },
        [2] = {
            type = 'integer',
            value = 2,
            vtype = 'integer',
        },
        [3] = {
            type = 'integer',
            value = 3,
            vtype = 'integer',
        },
    },
}

check[[
function test takes unit u returns nothing
    call test(null)
endfunction
]]
{
    type = 'function',
    name = 'test',
    file = 'war3map.j',
    line = 1,
    endline = 3,
    args = {
        [1] = {
            type = 'unit',
            name = 'u',
        },
        u = {
            type = 'unit',
            name = 'u',
        },
    },
    locals = {},
    [1] = {
        type = 'call',
        name = 'test',
        file = 'war3map.j',
        line = 2,
        [1] = {
            type = 'null',
            vtype = 'null',
        },
    },
}

check[[
function test takes nothing returns nothing
    local integer x
    set x = 1
endfunction
]]
{
    type = 'function',
    name = 'test',
    file = 'war3map.j',
    line = 1,
    endline = 4,
    locals = {
        [1] = {
            type = 'integer',
            name = 'x',
            file = 'war3map.j',
            line = 2,
        },
        x = {
            type = 'integer',
            name = 'x',
            file = 'war3map.j',
            line = 2,
        },
    },
    [1] = {
        type = 'set',
        name = 'x',
        file = 'war3map.j',
        line = 3,
        [1] = {
            type = 'integer',
            value = 1,
            vtype = 'integer',
        },
    },
}

check[[
function test takes nothing returns nothing
    local integer array x
    set x[5] = 1
endfunction
]]
{
    type = 'function',
    name = 'test',
    file = 'war3map.j',
    line = 1,
    endline = 4,
    locals = {
        [1] = {
            type = 'integer',
            name = 'x',
            array = true,
            file = 'war3map.j',
            line = 2,
        },
        x = {
            type = 'integer',
            name = 'x',
            array = true,
            file = 'war3map.j',
            line = 2,
        },
    },
    [1] = {
        type = 'seti',
        name = 'x',
        file = 'war3map.j',
        line = 3,
        [1] = {
            type = 'integer',
            value = 5,
            vtype = 'integer',
        },
        [2] = {
            type = 'integer',
            value = 1,
            vtype = 'integer',
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
    file = 'war3map.j',
    line = 1,
    endline = 3,
    locals = {},
    [1] = {
        type = 'return',
        file = 'war3map.j',
        line = 2,
    },
}

check[[
function test takes nothing returns integer
    return 0
endfunction
]]
{
    type = 'function',
    name = 'test',
    file = 'war3map.j',
    line = 1,
    endline = 3,
    returns = 'integer',
    locals = {},
    [1] = {
        type = 'return',
        file = 'war3map.j',
        line = 2,
        [1] = {
            type = 'integer',
            value = 0,
            vtype = 'integer',
        },
    },
}

check[[
function test takes nothing returns integer
    local integer array x
    call test()
    set x[5] = 1
    return 0
endfunction
]]
{
    type = 'function',
    name = 'test',
    file = 'war3map.j',
    line = 1,
    endline = 6,
    returns = 'integer',
    locals = {
        [1] = {
            type = 'integer',
            name = 'x',
            array = true,
            file = 'war3map.j',
            line = 2,
        },
        x = {
            type = 'integer',
            name = 'x',
            array = true,
            file = 'war3map.j',
            line = 2,
        },
    },
    [1] = {
        type = 'call',
        name = 'test',
        file = 'war3map.j',
        line = 3,
    },
    [2] = {
        type = 'seti',
        name = 'x',
        file = 'war3map.j',
        line = 4,
        [1] = {
            type = 'integer',
            value = 5,
            vtype = 'integer',
        },
        [2] = {
            type = 'integer',
            value = 1,
            vtype = 'integer',
        }
    },
    [3] = {
        type = 'return',
        file = 'war3map.j',
        line = 5,
        [1] = {
            type = 'integer',
            value = 0,
            vtype = 'integer',
        },
    },
}
