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
        exp = IGNORE,
    },
}

check[[
function test takes nothing returns nothing
    return test()
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'return',
        exp = {
            type = 'call',
            name = 'test',
            args = {},
        },
    },
}

check[[
function test takes nothing returns nothing
    return test(x, y, z)
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'return',
        exp = {
            type = 'call',
            name = 'test',
            args = {
                [1] = {
                    type = 'variable',
                    name = 'x',
                },
                [2] = {
                    type = 'variable',
                    name = 'y',
                },
                [3] = {
                    type = 'variable',
                    name = 'z',
                },
            },
        },
    },
}

check[[
function test takes nothing returns nothing
    return function test
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'return',
        exp = {
            type = 'function',
            name = 'test',
        },
    },
}

check[[
function test takes nothing returns nothing
    return function test
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'return',
        exp = {
            type = 'function',
            name = 'test',
        },
    },
}

check[[
function test takes nothing returns nothing
    return i
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'return',
        exp = {
            type = 'variable',
            name = 'i',
        },
    },
}

check[[
function test takes nothing returns nothing
    return i[x]
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'return',
        exp = {
            type = 'variable',
            name = 'i',
            index = {
                type = 'variable',
                name = 'x',
            },
        },
    },
}

check[[
function test takes nothing returns nothing
    return (x)
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'return',
        exp = {
            type = 'brackets',
            exp = {
                type = 'variable',
                name = 'x',
            },
        },
    },
}

check[[
function test takes nothing returns nothing
    return ((x))
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'return',
        exp = {
            type = 'brackets',
            exp = {
                type = 'brackets',
                exp = {
                    type = 'variable',
                    name = 'x',
                },
            },
        },
    },
}

check[[
function test takes nothing returns nothing
    return not x
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'return',
        exp = {
            type = 'operator',
            symbol = 'not',
            [1] = {
                type = 'variable',
                name = 'x',
            },
        },
    },
}

check[[
function test takes nothing returns nothing
    return not (x)
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'return',
        exp = {
            type = 'operator',
            symbol = 'not',
            [1] = {
                type = 'brackets',
                exp = {
                    type = 'variable',
                    name = 'x',
                },
            },
        },
    },
}

check[[
function test takes nothing returns nothing
    return not not x
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'return',
        exp = {
            type = 'operator',
            symbol = 'not',
            [1] = {
                type = 'operator',
                symbol = 'not',
                [1] = {
                    type = 'variable',
                    name = 'x',
                },
            },
        },
    },
}

check[[
function test takes nothing returns nothing
    return - x
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'return',
        exp = {
            type = 'negative',
            exp = {
                type = 'variable',
                name = 'x',
            },
        },
    },
}

check[[
function test takes nothing returns nothing
    return x * y
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'return',
        exp = {
            type = 'operator',
            symbol = '*',
            [1] = {
                type = 'variable',
                name = 'x',
            },
            [2] = {
                type = 'variable',
                name = 'y',
            },
        },
    },
}

check[[
function test takes nothing returns nothing
    return x * y / z
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'return',
        exp = {
            type = 'operator',
            symbol = '/',
            [1] = {
                type = 'operator',
                symbol = '*',
                [1] = {
                    type = 'variable',
                    name = 'x',
                },
                [2] = {
                    type = 'variable',
                    name = 'y',
                },
            },
            [2] = {
                type = 'variable',
                name = 'z',
            },
        },
    },
}

check[[
function test takes nothing returns nothing
    return x + y
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'return',
        exp = {
            type = 'operator',
            symbol = '+',
            [1] = {
                type = 'variable',
                name = 'x',
            },
            [2] = {
                type = 'variable',
                name = 'y',
            },
        },
    },
}

check[[
function test takes nothing returns nothing
    return x + y - z
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'return',
        exp = {
            type = 'operator',
            symbol = '-',
            [1] = {
                type = 'operator',
                symbol = '+',
                [1] = {
                    type = 'variable',
                    name = 'x',
                },
                [2] = {
                    type = 'variable',
                    name = 'y',
                },
            },
            [2] = {
                type = 'variable',
                name = 'z',
            },
        },
    },
}

check[[
function test takes nothing returns nothing
    return x * y + z
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'return',
        exp = {
            type = 'operator',
            symbol = '+',
            [1] = {
                type = 'operator',
                symbol = '*',
                [1] = {
                    type = 'variable',
                    name = 'x',
                },
                [2] = {
                    type = 'variable',
                    name = 'y',
                },
            },
            [2] = {
                type = 'variable',
                name = 'z',
            },
        },
    },
}

check[[
function test takes nothing returns nothing
    return x * (y + z)
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'return',
        exp = {
            type = 'operator',
            symbol = '*',
            [1] = {
                type = 'variable',
                name = 'x',
            },
            [2] = {
                type = 'brackets',
                exp = {
                    type = 'operator',
                    symbol = '+',
                    [1] = {
                        type = 'variable',
                        name = 'y',
                    },
                    [2] = {
                        type = 'variable',
                        name = 'z',
                    },
                },
            },
        },
    },
}

check[[
function test takes nothing returns nothing
    return x + y * z
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'return',
        exp = {
            type = 'operator',
            symbol = '+',
            [1] = {
                type = 'variable',
                name = 'x',
            },
            [2] = {
                type = 'operator',
                symbol = '*',
                [1] = {
                    type = 'variable',
                    name = 'y',
                },
                [2] = {
                    type = 'variable',
                    name = 'z',
                },
            },
        },
    },
}

check[[
function test takes nothing returns nothing
    return (x + y) * z
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'return',
        exp = {
            type = 'operator',
            symbol = '*',
            [1] = {
                type = 'brackets',
                exp = {
                    type = 'operator',
                    symbol = '+',
                    [1] = {
                        type = 'variable',
                        name = 'x',
                    },
                    [2] = {
                        type = 'variable',
                        name = 'y',
                    },
                },
            },
            [2] = {
                type = 'variable',
                name = 'z',
            },
        },
    },
}

check[[
function test takes nothing returns nothing
    return x == y
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'return',
        exp = {
            type = 'operator',
            symbol = '==',
            [1] = {
                type = 'variable',
                name = 'x',
            },
            [2] = {
                type = 'variable',
                name = 'y',
            },
        },
    },
}

check[[
function test takes nothing returns nothing
    return x == y != z
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'return',
        exp = {
            type = 'operator',
            symbol = '!=',
            [1] = {
                type = 'operator',
                symbol = '==',
                [1] = {
                    type = 'variable',
                    name = 'x',
                },
                [2] = {
                    type = 'variable',
                    name = 'y',
                },
            },
            [2] = {
                type = 'variable',
                name = 'z',
            },
        },
    },
}

check[[
function test takes nothing returns nothing
    return x == not y
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'return',
        exp = {
            type = 'operator',
            symbol = '==',
            [1] = {
                type = 'variable',
                name = 'x',
            },
            [2] = {
                type = 'operator',
                symbol = 'not',
                [1] = {
                    type = 'variable',
                    name = 'y',
                },
            },
        },
    },
}

check[[
function test takes nothing returns nothing
    return x and y
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'return',
        exp = {
            type = 'operator',
            symbol = 'and',
            [1] = {
                type = 'variable',
                name = 'x',
            },
            [2] = {
                type = 'variable',
                name = 'y',
            },
        },
    },
}

check[[
function test takes nothing returns nothing
    return x and y == z
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'return',
        exp = {
            type = 'operator',
            symbol = 'and',
            [1] = {
                type = 'variable',
                name = 'x',
            },
            [2] = {
                type = 'operator',
                symbol = '==',
                [1] = {
                    type = 'variable',
                    name = 'y',
                },
                [2] = {
                    type = 'variable',
                    name = 'z',
                },
            },
        },
    },
}

check[[
function test takes nothing returns nothing
    return x or y
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'return',
        exp = {
            type = 'operator',
            symbol = 'or',
            [1] = {
                type = 'variable',
                name = 'x',
            },
            [2] = {
                type = 'variable',
                name = 'y',
            },
        },
    },
}

check[[
function test takes nothing returns nothing
    return x and y or z
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'return',
        exp = {
            type = 'operator',
            symbol = 'or',
            [1] = {
                type = 'operator',
                symbol = 'and',
                [1] = {
                    type = 'variable',
                    name = 'x',
                },
                [2] = {
                    type = 'variable',
                    name = 'y',
                },
            },
            [2] = {
                type = 'variable',
                name = 'z',
            },
        },
    },
}
