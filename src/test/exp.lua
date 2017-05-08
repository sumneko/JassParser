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
    return test()
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
            type = 'call',
            name = 'test',
            vtype = 'integer',
        },
    },
}

check[[
function test takes integer x, integer y, integer z returns integer
    return test(x, y, z)
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
        x = {
            type = 'integer',
            name = 'x',
        },
        y = {
            type = 'integer',
            name = 'y',
        },
        z = {
            type = 'integer',
            name = 'z',
        },
    },
    returns = 'integer',
    locals = {},
    [1] = {
        type = 'return',
        file = 'war3map.j',
        line = 2,
        [1] = {
            type = 'call',
            name = 'test',
            vtype = 'integer',
            [1] = {
                type = 'var',
                name = 'x',
                vtype = 'integer',
            },
            [2] = {
                type = 'var',
                name = 'y',
                vtype = 'integer',
            },
            [3] = {
                type = 'var',
                name = 'z',
                vtype = 'integer',
            },
        },
    },
}

check[[
function test takes nothing returns code
    return function test
endfunction
]]
{
    type = 'function',
    name = 'test',
    file = 'war3map.j',
    line = 1,
    endline = 3,
    returns = 'code',
    locals = {},
    [1] = {
        type = 'return',
        file = 'war3map.j',
        line = 2,
        [1] = {
            type = 'code',
            name = 'test',
            vtype = 'code',
        },
    },
}

check[[
function test takes integer i returns integer
    return i
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
            name = 'i',
        },
        i = {
            type = 'integer',
            name = 'i',
        },
    },
    returns = 'integer',
    locals = {},
    [1] = {
        type = 'return',
        file = 'war3map.j',
        line = 2,
        [1] = {
            type = 'var',
            name = 'i',
            vtype = 'integer'
        },
    },
}

check[[
function test takes integer i returns integer
    local integer array x
    return x[i]
endfunction
]]
{
    type = 'function',
    name = 'test',
    file = 'war3map.j',
    line = 1,
    endline = 4,
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
        type = 'return',
        file = 'war3map.j',
        line = 3,
        [1] = {
            type = 'vari',
            name = 'x',
            vtype = 'integer',
            [1] = {
                type = 'var',
                name = 'i',
                vtype = 'integer',
            },
        },
    },
}

check[[
function test takes nothing returns integer
    return (1)
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
            type = 'paren',
            vtype = 'integer',
            [1] = {
                type = 'integer',
                value = 1,
                vtype = 'integer',
            },
        },
    },
}

check[[
function test takes nothing returns integer
    return ((1))
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
            type = 'paren',
            vtype = 'integer',
            [1] = {
                type = 'paren',
                vtype = 'integer',
                [1] = {
                    type = 'integer',
                    value = 1,
                    vtype = 'integer',
                },
            },
        },
    },
}

check[[
function test takes nothing returns boolean
    return not true
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
            type = 'not',
            vtype = 'boolean',
            [1] = {
                type = 'boolean',
                value = true,
                vtype = 'boolean',
            },
        },
    },
}

check[[
function test takes nothing returns boolean
    return not (true)
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
            type = 'not',
            vtype = 'boolean',
            [1] = {
                type = 'paren',
                vtype = 'boolean',
                [1] = {
                    type = 'boolean',
                    value = true,
                    vtype = 'boolean',
                },
            },
        },
    },
}

check[[
function test takes nothing returns boolean
    return not not true
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
            type = 'not',
            vtype = 'boolean',
            [1] = {
                type = 'not',
                vtype = 'boolean',
                [1] = {
                    type = 'boolean',
                    value = true,
                    vtype = 'boolean',
                },
            },
        },
    },
}

check[[
function test takes integer x returns integer
    return - x
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
            name = 'x',
        },
        x = {
            type = 'integer',
            name = 'x',
        },
    },
    returns = 'integer',
    locals = {},
    [1] = {
        type = 'return',
        file = 'war3map.j',
        line = 2,
        [1] = {
            type = 'neg',
            vtype = 'integer',
            [1] = {
                type = 'var',
                name = 'x',
                vtype = 'integer',
            },
        },
    },
}

check[[
function test takes nothing returns integer
    return 1 * 1
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
            type = '*',
            vtype = 'integer',
            [1] = {
                type = 'integer',
                value = 1,
                vtype = 'integer',
            },
            [2] = {
                type = 'integer',
                value = 1,
                vtype = 'integer',
            },
        },
    },
}

check[[
function test takes nothing returns integer
    return 1 * 1 / 1
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
            type = '/',
            vtype = 'integer',
            [1] = {
                type = '*',
                vtype = 'integer',
                [1] = {
                    type = 'integer',
                    value = 1,
                    vtype = 'integer',
                },
                [2] = {
                    type = 'integer',
                    value = 1,
                    vtype = 'integer',
                },
            },
            [2] = {
                type = 'integer',
                value = 1,
                vtype = 'integer',
            },
        },
    },
}

check[[
function test takes nothing returns integer
    return 1 + 1
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
            type = '+',
            vtype = 'integer',
            [1] = {
                type = 'integer',
                value = 1,
                vtype = 'integer',
            },
            [2] = {
                type = 'integer',
                value = 1,
                vtype = 'integer',
            },
        },
    },
}

check[[
function test takes nothing returns integer
    return 1 + 1 - 1
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
            type = '-',
            vtype = 'integer',
            [1] = {
                type = '+',
                vtype = 'integer',
                [1] = {
                    type = 'integer',
                    value = 1,
                    vtype = 'integer',
                },
                [2] = {
                    type = 'integer',
                    value = 1,
                    vtype = 'integer',
                },
            },
            [2] = {
                type = 'integer',
                value = 1,
                vtype = 'integer',
            },
        },
    },
}

check[[
function test takes nothing returns integer
    return 1 * 1 + 1
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
            type = '+',
            vtype = 'integer',
            [1] = {
                type = '*',
                vtype = 'integer',
                [1] = {
                    type = 'integer',
                    value = 1,
                    vtype = 'integer',
                },
                [2] = {
                    type = 'integer',
                    value = 1,
                    vtype = 'integer',
                },
            },
            [2] = {
                type = 'integer',
                value = 1,
                vtype = 'integer',
            },
        },
    },
}

check[[
function test takes nothing returns integer
    return 1 * (1 + 1)
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
            type = '*',
            vtype = 'integer',
            [1] = {
                type = 'integer',
                value = 1,
                vtype = 'integer',
            },
            [2] = {
                type = 'paren',
                vtype = 'integer',
                [1] = {
                    type = '+',
                    vtype = 'integer',
                    [1] = {
                        type = 'integer',
                        value = 1,
                        vtype = 'integer',
                    },
                    [2] = {
                        type = 'integer',
                        value = 1,
                        vtype = 'integer',
                    },
                },
            },
        },
    },
}

check[[
function test takes nothing returns integer
    return 1 + 1 * 1
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
            type = '+',
            vtype = 'integer',
            [1] = {
                type = 'integer',
                value = 1,
                vtype = 'integer',
            },
            [2] = {
                type = '*',
                vtype = 'integer',
                [1] = {
                    type = 'integer',
                    value = 1,
                    vtype = 'integer',
                },
                [2] = {
                    type = 'integer',
                    value = 1,
                    vtype = 'integer',
                },
            },
        },
    },
}

check[[
function test takes nothing returns integer
    return (1 + 1) * 1
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
            type = '*',
            vtype = 'integer',
            [1] = {
                type = 'paren',
                vtype = 'integer',
                [1] = {
                    type = '+',
                    vtype = 'integer',
                    [1] = {
                        type = 'integer',
                        value = 1,
                        vtype = 'integer',
                    },
                    [2] = {
                        type = 'integer',
                        value = 1,
                        vtype = 'integer',
                    },
                },
            },
            [2] = {
                type = 'integer',
                value = 1,
                vtype = 'integer',
            },
        },
    },
}

check[[
function test takes nothing returns boolean
    return true == true
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
            type = '==',
            vtype = 'boolean',
            [1] = {
                type = 'boolean',
                value = true,
                vtype = 'boolean',
            },
            [2] = {
                type = 'boolean',
                value = true,
                vtype = 'boolean',
            },
        },
    },
}

check[[
function test takes nothing returns boolean
    return true == true != true
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
            type = '!=',
            vtype = 'boolean',
            [1] = {
                type = '==',
                vtype = 'boolean',
                [1] = {
                    type = 'boolean',
                    value = true,
                    vtype = 'boolean',
                },
                [2] = {
                    type = 'boolean',
                    value = true,
                    vtype = 'boolean',
                },
            },
            [2] = {
                type = 'boolean',
                value = true,
                vtype = 'boolean',
            },
        },
    },
}

check[[
function test takes nothing returns boolean
    return true == not true
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
            type = '==',
            vtype = 'boolean',
            [1] = {
                type = 'boolean',
                value = true,
                vtype = 'boolean',
            },
            [2] = {
                type = 'not',
                vtype = 'boolean',
                [1] = {
                    type = 'boolean',
                    value = true,
                    vtype = 'boolean',
                },
            },
        },
    },
}

check[[
function test takes nothing returns boolean
    return true and true
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
            type = 'and',
            vtype = 'boolean',
            [1] = {
                type = 'boolean',
                value = true,
                vtype = 'boolean',
            },
            [2] = {
                type = 'boolean',
                value = true,
                vtype = 'boolean',
            },
        },
    },
}

check[[
function test takes nothing returns boolean
    return true and true == true
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
            type = 'and',
            vtype = 'boolean',
            [1] = {
                type = 'boolean',
                value = true,
                vtype = 'boolean',
            },
            [2] = {
                type = '==',
                vtype = 'boolean',
                [1] = {
                    type = 'boolean',
                    value = true,
                    vtype = 'boolean',
                },
                [2] = {
                    type = 'boolean',
                    value = true,
                    vtype = 'boolean',
                },
            },
        },
    },
}

check[[
function test takes nothing returns boolean
    return true or true
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
            type = 'or',
            vtype = 'boolean',
            [1] = {
                type = 'boolean',
                value = true,
                vtype = 'boolean',
            },
            [2] = {
                type = 'boolean',
                value = true,
                vtype = 'boolean',
            },
        },
    },
}

check[[
function test takes nothing returns boolean
    return true and true or true
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
            type = 'or',
            vtype = 'boolean',
            [1] = {
                type = 'and',
                vtype = 'boolean',
                [1] = {
                    type = 'boolean',
                    value = true,
                    vtype = 'boolean',
                },
                [2] = {
                    type = 'boolean',
                    value = true,
                    vtype = 'boolean',
                },
            },
            [2] = {
                type = 'boolean',
                value = true,
                vtype = 'boolean',
            },
        },
    },
}
