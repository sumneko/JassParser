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
            [1] = 0,
        },
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
        [1] = {
            type = 'call',
            name = 'test',
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
        [1] = {
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
        [1] = {
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
        [1] = {
            type = 'var',
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
        [1] = {
            type = 'vari',
            name = 'i',
            [1] = {
                type = 'var',
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
        [1] = {
            type = 'paren',
            [1] = {
                type = 'var',
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
        [1] = {
            type = 'paren',
            [1] = {
                type = 'paren',
                [1] = {
                    type = 'var',
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
        [1] = {
            type = 'not',
            [1] = {
                type = 'var',
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
        [1] = {
            type = 'not',
            [1] = {
                type = 'paren',
                [1] = {
                    type = 'var',
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
        [1] = {
            type = 'not',
            [1] = {
                type = 'not',
                [1] = {
                    type = 'var',
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
        [1] = {
            type = 'neg',
            [1] = {
                type = 'var',
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
        [1] = {
            type = '*',
            [1] = {
                type = 'var',
                name = 'x',
            },
            [2] = {
                type = 'var',
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
        [1] = {
            type = '/',
            [1] = {
                type = '*',
                [1] = {
                    type = 'var',
                    name = 'x',
                },
                [2] = {
                    type = 'var',
                    name = 'y',
                },
            },
            [2] = {
                type = 'var',
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
        [1] = {
            type = '+',
            [1] = {
                type = 'var',
                name = 'x',
            },
            [2] = {
                type = 'var',
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
        [1] = {
            type = '-',
            [1] = {
                type = '+',
                [1] = {
                    type = 'var',
                    name = 'x',
                },
                [2] = {
                    type = 'var',
                    name = 'y',
                },
            },
            [2] = {
                type = 'var',
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
        [1] = {
            type = '+',
            [1] = {
                type = '*',
                [1] = {
                    type = 'var',
                    name = 'x',
                },
                [2] = {
                    type = 'var',
                    name = 'y',
                },
            },
            [2] = {
                type = 'var',
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
        [1] = {
            type = '*',
            [1] = {
                type = 'var',
                name = 'x',
            },
            [2] = {
                type = 'paren',
                [1] = {
                    type = '+',
                    [1] = {
                        type = 'var',
                        name = 'y',
                    },
                    [2] = {
                        type = 'var',
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
        [1] = {
            type = '+',
            [1] = {
                type = 'var',
                name = 'x',
            },
            [2] = {
                type = '*',
                [1] = {
                    type = 'var',
                    name = 'y',
                },
                [2] = {
                    type = 'var',
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
        [1] = {
            type = '*',
            [1] = {
                type = 'paren',
                [1] = {
                    type = '+',
                    [1] = {
                        type = 'var',
                        name = 'x',
                    },
                    [2] = {
                        type = 'var',
                        name = 'y',
                    },
                },
            },
            [2] = {
                type = 'var',
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
        [1] = {
            type = '==',
            [1] = {
                type = 'var',
                name = 'x',
            },
            [2] = {
                type = 'var',
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
        [1] = {
            type = '!=',
            [1] = {
                type = '==',
                [1] = {
                    type = 'var',
                    name = 'x',
                },
                [2] = {
                    type = 'var',
                    name = 'y',
                },
            },
            [2] = {
                type = 'var',
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
        [1] = {
            type = '==',
            [1] = {
                type = 'var',
                name = 'x',
            },
            [2] = {
                type = 'not',
                [1] = {
                    type = 'var',
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
        [1] = {
            type = 'and',
            [1] = {
                type = 'var',
                name = 'x',
            },
            [2] = {
                type = 'var',
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
        [1] = {
            type = 'and',
            [1] = {
                type = 'var',
                name = 'x',
            },
            [2] = {
                type = '==',
                [1] = {
                    type = 'var',
                    name = 'y',
                },
                [2] = {
                    type = 'var',
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
        [1] = {
            type = 'or',
            [1] = {
                type = 'var',
                name = 'x',
            },
            [2] = {
                type = 'var',
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
        [1] = {
            type = 'or',
            [1] = {
                type = 'and',
                [1] = {
                    type = 'var',
                    name = 'x',
                },
                [2] = {
                    type = 'var',
                    name = 'y',
                },
            },
            [2] = {
                type = 'var',
                name = 'z',
            },
        },
    },
}
