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
            exp = IGNORE,
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
            exp = IGNORE,
            [1] = {
                type = 'call',
                exp = IGNORE,
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
            exp = IGNORE,
            [1] = {
                type = 'set',
                name = 'x',
                exp = IGNORE,
            },
        },
        [2] = {
            exp = IGNORE,
            [1] = {
                type = 'set',
                name = 'y',
                exp = IGNORE,
            },
        },
        [3] = {
            exp = IGNORE,
            [1] = {
                type = 'set',
                name = 'z',
                exp = IGNORE,
            },
        },
        [4] = {
            [1] = {
                type = 'set',
                name = 'w',
                exp = IGNORE,
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
            exp = IGNORE,
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
                exp = IGNORE,
                [1] = {
                    type = 'exit',
                    exp = IGNORE,
                },
            },
        },
    },
}

