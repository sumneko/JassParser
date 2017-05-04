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
    return -1
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
            value = -1,
        },
    },
}

check[[
function test takes nothing returns nothing
    return - 1
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
            value = -1,
        },
    },
}

check[[
function test takes nothing returns nothing
    return $A
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
            value = 10,
        },
    },
}

check[[
function test takes nothing returns nothing
    return -$A
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
            value = -10,
        },
    },
}

check[[
function test takes nothing returns nothing
    return - $A
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
            value = -10,
        },
    },
}

check[[
function test takes nothing returns nothing
    return 0x10
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
            value = 16,
        },
    },
}

check[[
function test takes nothing returns nothing
    return -0x10
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
            value = -16,
        },
    },
}

check[[
function test takes nothing returns nothing
    return - 0x10
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
            value = -16,
        },
    },
}

check[[
function test takes nothing returns nothing
    return 'A'
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
            value = 65,
        },
    },
}

check[[
function test takes nothing returns nothing
    return -'A'
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
            value = -65,
        },
    },
}

check[[
function test takes nothing returns nothing
    return - 'A'
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
            value = -65,
        },
    },
}

check[[
function test takes nothing returns nothing
    return 'Aloc'
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
            value = 1097625443,
        },
    },
}

check[[
function test takes nothing returns nothing
    return 1.0
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'return',
        [1] = {
            type = 'real',
            value = 1.0,
        },
    },
}

check[[
function test takes nothing returns nothing
    return 1.
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'return',
        [1] = {
            type = 'real',
            value = 1.0,
        },
    },
}

check[[
function test takes nothing returns nothing
    return .1
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'return',
        [1] = {
            type = 'real',
            value = 0.1,
        },
    },
}

check[[
function test takes nothing returns nothing
    return -1.0
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'return',
        [1] = {
            type = 'real',
            value = -1.0,
        },
    },
}

check[[
function test takes nothing returns nothing
    return -1.
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'return',
        [1] = {
            type = 'real',
            value = -1.0,
        },
    },
}

check[[
function test takes nothing returns nothing
    return -.1
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'return',
        [1] = {
            type = 'real',
            value = -0.1,
        },
    },
}

check[[
function test takes nothing returns nothing
    return - 1.0
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'return',
        [1] = {
            type = 'real',
            value = -1.0,
        },
    },
}

check[[
function test takes nothing returns nothing
    return - 1.
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'return',
        [1] = {
            type = 'real',
            value = -1.0,
        },
    },
}

check[[
function test takes nothing returns nothing
    return - .1
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'return',
        [1] = {
            type = 'real',
            value = -0.1,
        },
    },
}

check[[
function test takes nothing returns nothing
    return true
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'return',
        [1] = {
            type = 'boolean',
            value = true,
        },
    },
}

check[[
function test takes nothing returns nothing
    return false
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'return',
        [1] = {
            type = 'boolean',
            value = false,
        },
    },
}

check[[
function test takes nothing returns nothing
    return null
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'return',
        [1] = {
            type = 'null',
        },
    },
}

check[[
function test takes nothing returns nothing
    return "1"
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'return',
        [1] = {
            type = 'string',
            value = '1',
        },
    },
}

check[[
function test takes nothing returns nothing
    return "1\"\\\b\t\r\n\f"
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'return',
        [1] = {
            type = 'string',
            value = '1"\\\b\t\r\n\f',
        },
    },
}
