check[[
function test takes nothing returns nothing
    if a then
    endif
endfunction
]]
{
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'if',
        line = 2,
        [1] = {
            type = 'if',
            line = 2,
            condition = {
                type = 'var',
                name = 'a',
            },
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
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'if',
        line = 2,
        [1] = {
            type = 'if',
            line = 2,
            condition = {
                type = 'var',
                name = 'a',
            },
            [1] = {
                type = 'call',
                name = 'test',
                line = 3,
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
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'if',
        line = 2,
        [1] = {
            type = 'if',
            line = 2,
            condition = {
                type = 'var',
                name = 'a',
            },
            [1] = {
                type = 'set',
                name = 'x',
                line = 3,
                [1] = {
                    type = 'integer',
                    value = 1,
                },
            },
        },
        [2] = {
            type = 'elseif',
            line = 4,
            condition = {
                type = 'var',
                name = 'b',
            },
            [1] = {
                type = 'set',
                name = 'y',
                line = 5,
                [1] = {
                    type = 'integer',
                    value = 1,
                },
            },
        },
        [3] = {
            type = 'elseif',
            line = 6,
            condition = {
                type = 'var',
                name = 'c',
            },
            [1] = {
                type = 'set',
                name = 'z',
                line = 7,
                [1] = {
                    type = 'integer',
                    value = 1,
                },
            },
        },
        [4] = {
            type = 'else',
            line = 8,
            [1] = {
                type = 'set',
                name = 'w',
                line = 9,
                [1] = {
                    type = 'integer',
                    value = 1,
                },
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
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'loop',
        line = 2,
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
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'loop',
        line = 2,
        [1] = {
            type = 'exit',
            line = 3,
            [1] = {
                type = 'boolean',
                value = true,
            },
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
    type = 'function',
    name = 'test',
    locals = {},
    [1] = {
        type = 'loop',
        line = 2,
        [1] = {
            type = 'if',
            line = 3,
            [1] = {
                type = 'if',
                line = 3,
                condition = {
                    type = 'var',
                    name = 'a',
                },
                [1] = {
                    type = 'exit',
                    line = 4,
                    [1] = {
                        type = 'boolean',
                        value = true,
                    },
                },
            },
        },
    },
}

