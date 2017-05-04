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
        [1] = {
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
        [1] = {
            condition = {
                type = 'var',
                name = 'a',
            },
            [1] = {
                type = 'call',
                name = 'test',
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
        [1] = {
            condition = {
                type = 'var',
                name = 'a',
            },
            [1] = {
                type = 'set',
                name = 'x',
                [1] = {
                    type = 'integer',
                    value = 1,
                },
            },
        },
        [2] = {
            condition = {
                type = 'var',
                name = 'b',
            },
            [1] = {
                type = 'set',
                name = 'y',
                [1] = {
                    type = 'integer',
                    value = 1,
                },
            },
        },
        [3] = {
            condition = {
                type = 'var',
                name = 'c',
            },
            [1] = {
                type = 'set',
                name = 'z',
                [1] = {
                    type = 'integer',
                    value = 1,
                },
            },
        },
        [4] = {
            [1] = {
                type = 'set',
                name = 'w',
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
        [1] = {
            type = 'exit',
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
        [1] = {
            type = 'if',
            [1] = {
                condition = {
                    type = 'var',
                    name = 'a',
                },
                [1] = {
                    type = 'exit',
                    [1] = {
                        type = 'boolean',
                        value = true,
                    },
                },
            },
        },
    },
}

