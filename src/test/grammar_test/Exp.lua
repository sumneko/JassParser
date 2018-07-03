check '0'
{
    type = 'integer',
    value = 0,
}

check 'x'
{
    type = 'var',
    name = 'x',
}

check 'x[0]'
{
    type = 'vari',
    name = 'x',
    [1] = {
        type = 'integer',
        value = 0,
    }
}

check 'x[x[0]]'
{
    type = 'vari',
    name = 'x',
    [1] = {
        type = 'vari',
        name = 'x',
        [1] = {
            type = 'integer',
            value = 0,
        }
    }
}

check 'test()'
{
    type = 'call',
    name = 'test',
}

check 'test(x, y, z)'
{
    type = 'call',
    name = 'test',
    [1] = {
        type = 'var',
        name = 'x',
    },
    [2] = {
        type = 'var',
        name = 'y',
    },
    [3] = {
        type = 'var',
        name = 'z',
    },
}

check 'function test'
{
    type = 'code',
    name = 'test',
}

check '(1)'
{
    type = 'integer',
    value = 1,
}

check '((1))'
{
    type = 'integer',
    value = 1,
}

check 'not true'
{
    type = 'not',
    [1] = {
        type = 'boolean',
        value = true,
    },
}

check 'not not true'
{
    type = 'not',
    [1] = {
        type = 'not',
        [1] = {
            type = 'boolean',
            value = true,
        },
    },
}

check 'nottrue'
{
    type = 'var',
    name = 'nottrue',
}
do return end

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
                type = 'boolean',
                value = true,
                vtype = 'boolean',
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
            type = 'and',
            vtype = 'boolean',
            [1] = {
                type = 'boolean',
                value = true,
                vtype = 'boolean',
            },
            [2] = {
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
    },
}
