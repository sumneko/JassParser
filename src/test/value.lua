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
            vtype = 'integer'
        },
    },
}

check[[
function test takes nothing returns integer
    return -1
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
            value = -1,
            vtype = 'integer'
        },
    },
}

check[[
function test takes nothing returns integer
    return - 1
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
            value = -1,
            vtype = 'integer'
        },
    },
}

check[[
function test takes nothing returns integer
    return $A
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
            value = 10,
            vtype = 'integer'
        },
    },
}

check[[
function test takes nothing returns integer
    return -$A
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
            value = -10,
            vtype = 'integer'
        },
    },
}

check[[
function test takes nothing returns integer
    return - $A
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
            value = -10,
            vtype = 'integer'
        },
    },
}

check[[
function test takes nothing returns integer
    return 0x10
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
            value = 16,
            vtype = 'integer'
        },
    },
}

check[[
function test takes nothing returns integer
    return -0x10
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
            value = -16,
            vtype = 'integer'
        },
    },
}

check[[
function test takes nothing returns integer
    return - 0x10
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
            value = -16,
            vtype = 'integer'
        },
    },
}

check[[
function test takes nothing returns integer
    return 010
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
            value = 8,
            vtype = 'integer'
        },
    },
}

check[[
function test takes nothing returns integer
    return -010
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
            value = -8,
            vtype = 'integer'
        },
    },
}

check[[
function test takes nothing returns integer
    return - 010
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
            value = -8,
            vtype = 'integer'
        },
    },
}

check[[
function test takes nothing returns integer
    return 'A'
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
            value = 65,
            vtype = 'integer'
        },
    },
}

check[[
function test takes nothing returns integer
    return -'A'
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
            value = -65,
            vtype = 'integer'
        },
    },
}

check[[
function test takes nothing returns integer
    return - 'A'
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
            value = -65,
            vtype = 'integer'
        },
    },
}

check[[
function test takes nothing returns integer
    return 'Aloc'
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
            value = 1097625443,
            vtype = 'integer'
        },
    },
}

check[[
function test takes nothing returns real
    return 1.0
endfunction
]]
{
    type = 'function',
    name = 'test',
    file = 'war3map.j',
    line = 1,
    endline = 3,
    returns = 'real',
    locals = {},
    [1] = {
        type = 'return',
        file = 'war3map.j',
        line = 2,
        [1] = {
            type = 'real',
            value = '1.0',
            vtype = 'real'
        },
    },
}

check[[
function test takes nothing returns real
    return 1.
endfunction
]]
{
    type = 'function',
    name = 'test',
    file = 'war3map.j',
    line = 1,
    endline = 3,
    returns = 'real',
    locals = {},
    [1] = {
        type = 'return',
        file = 'war3map.j',
        line = 2,
        [1] = {
            type = 'real',
            value = '1.',
            vtype = 'real'
        },
    },
}

check[[
function test takes nothing returns real
    return .1
endfunction
]]
{
    type = 'function',
    name = 'test',
    file = 'war3map.j',
    line = 1,
    endline = 3,
    returns = 'real',
    locals = {},
    [1] = {
        type = 'return',
        file = 'war3map.j',
        line = 2,
        [1] = {
            type = 'real',
            value = '.1',
            vtype = 'real'
        },
    },
}

check[[
function test takes nothing returns real
    return -1.0
endfunction
]]
{
    type = 'function',
    name = 'test',
    file = 'war3map.j',
    line = 1,
    endline = 3,
    returns = 'real',
    locals = {},
    [1] = {
        type = 'return',
        file = 'war3map.j',
        line = 2,
        [1] = {
            type = 'real',
            value = '-1.0',
            vtype = 'real'
        },
    },
}

check[[
function test takes nothing returns real
    return -1.
endfunction
]]
{
    type = 'function',
    name = 'test',
    file = 'war3map.j',
    line = 1,
    endline = 3,
    returns = 'real',
    locals = {},
    [1] = {
        type = 'return',
        file = 'war3map.j',
        line = 2,
        [1] = {
            type = 'real',
            value = '-1.',
            vtype = 'real'
        },
    },
}

check[[
function test takes nothing returns real
    return -.1
endfunction
]]
{
    type = 'function',
    name = 'test',
    file = 'war3map.j',
    line = 1,
    endline = 3,
    returns = 'real',
    locals = {},
    [1] = {
        type = 'return',
        file = 'war3map.j',
        line = 2,
        [1] = {
            type = 'real',
            value = '-.1',
            vtype = 'real'
        },
    },
}

check[[
function test takes nothing returns real
    return - 1.0
endfunction
]]
{
    type = 'function',
    name = 'test',
    file = 'war3map.j',
    line = 1,
    endline = 3,
    returns = 'real',
    locals = {},
    [1] = {
        type = 'return',
        file = 'war3map.j',
        line = 2,
        [1] = {
            type = 'real',
            value = '- 1.0',
            vtype = 'real'
        },
    },
}

check[[
function test takes nothing returns real
    return - 1.
endfunction
]]
{
    type = 'function',
    name = 'test',
    file = 'war3map.j',
    line = 1,
    endline = 3,
    returns = 'real',
    locals = {},
    [1] = {
        type = 'return',
        file = 'war3map.j',
        line = 2,
        [1] = {
            type = 'real',
            value = '- 1.',
            vtype = 'real'
        },
    },
}

check[[
function test takes nothing returns real
    return - .1
endfunction
]]
{
    type = 'function',
    name = 'test',
    file = 'war3map.j',
    line = 1,
    endline = 3,
    returns = 'real',
    locals = {},
    [1] = {
        type = 'return',
        file = 'war3map.j',
        line = 2,
        [1] = {
            type = 'real',
            value = '- .1',
            vtype = 'real'
        },
    },
}

check[[
function test takes nothing returns real
    return 0.999999999
endfunction
]]
{
    type = 'function',
    name = 'test',
    file = 'war3map.j',
    line = 1,
    endline = 3,
    returns = 'real',
    locals = {},
    [1] = {
        type = 'return',
        file = 'war3map.j',
        line = 2,
        [1] = {
            type = 'real',
            value = '0.999999999',
            vtype = 'real'
        },
    },
}

check[[
function test takes nothing returns boolean
    return true
endfunction
]]
{
    type = 'function',
    name = 'test',
    file = 'war3map.j',
    line = 1,
    endline = 3,
    returns = 'boolean',
    locals = {},
    [1] = {
        type = 'return',
        file = 'war3map.j',
        line = 2,
        [1] = {
            type = 'boolean',
            value = true,
            vtype = 'boolean'
        },
    },
}

check[[
function test takes nothing returns boolean
    return false
endfunction
]]
{
    type = 'function',
    name = 'test',
    file = 'war3map.j',
    line = 1,
    endline = 3,
    returns = 'boolean',
    locals = {},
    [1] = {
        type = 'return',
        file = 'war3map.j',
        line = 2,
        [1] = {
            type = 'boolean',
            value = false,
            vtype = 'boolean'
        },
    },
}

check[[
function test takes nothing returns handle
    return null
endfunction
]]
{
    type = 'function',
    name = 'test',
    file = 'war3map.j',
    line = 1,
    endline = 3,
    returns = 'handle',
    locals = {},
    [1] = {
        type = 'return',
        file = 'war3map.j',
        line = 2,
        [1] = {
            type = 'null',
            vtype = 'null',
        },
    },
}

check[[
function test takes nothing returns string
    return "1"
endfunction
]]
{
    type = 'function',
    name = 'test',
    file = 'war3map.j',
    line = 1,
    endline = 3,
    returns = 'string',
    locals = {},
    [1] = {
        type = 'return',
        file = 'war3map.j',
        line = 2,
        [1] = {
            type = 'string',
            value = '1',
            vtype = 'string'
        },
    },
}

check[[
function test takes nothing returns string
    return "1\"\\\b\t\r\n\f"
endfunction
]]
{
    type = 'function',
    name = 'test',
    file = 'war3map.j',
    line = 1,
    endline = 3,
    returns = 'string',
    locals = {},
    [1] = {
        type = 'return',
        file = 'war3map.j',
        line = 2,
        [1] = {
            type = 'string',
            value = [[1\"\\\b\t\r\n\f]],
            vtype = 'string'
        },
    },
}
