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
}

check[[
constant function test takes nothing returns nothing
endfunction
]]
{
    type = 'function',
    name = 'test',
    file = 'war3map.j',
    line = 1,
    endline = 2,
    constant = true,
}

check[[
function test takes integer x returns nothing
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
            name = 'x',
        },
    },
}

check[[
function test takes integer x, integer y, integer z returns nothing
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
            name = 'x',
        },
        [2] = {
            type = 'integer',
            name = 'y',
        },
        [3] = {
            type = 'integer',
            name = 'z',
        },
    },
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
    [1] = {
        type = 'call',
        name = 'test',
        file = 'war3map.j',
        line = 2,
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
    },
    [1] = {
        type = 'set',
        name = 'x',
        file = 'war3map.j',
        line = 3,
        [1] = {
            type = 'integer',
            value = 1,
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
        },
        [2] = {
            type = 'integer',
            value = 1,
        }
    },
    [3] = {
        type = 'return',
        file = 'war3map.j',
        line = 5,
        [1] = {
            type = 'integer',
            value = 0,
        },
    },
}
