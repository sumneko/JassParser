check[[
globals
endglobals
]]
{
    type = 'globals',
    line = 1,
}

check[[
globals
endglobals
globals
endglobals
]]
{
    type = 'globals',
    line = 1,
}

check[[
globals
    integer i
endglobals
]]
{
    type = 'globals',
    line = 1,
    [1] = {
        name = 'i',
        type = 'integer',
        line = 2,
    },
}

check[[
globals
    boolean array b
endglobals
]]
{
    type = 'globals',
    line = 1,
    [1] = {
        name = 'b',
        type = 'boolean',
        array = true,
        line = 2,
    },
}

check[[
globals
    constant integer ci
endglobals
]]
{
    type = 'globals',
    line = 1,
    [1] = {
        name = 'ci',
        type = 'integer',
        constant = true,
        line = 2,
    },
}

check[[
globals
    constant boolean array b
endglobals
]]
{
    type = 'globals',
    line = 1,
    [1] = {
        name = 'b',
        type = 'boolean',
        array = true,
        constant = true,
        line = 2,
    },
}

check[[
globals
    integer i = 0
endglobals
]]
{
    type = 'globals',
    line = 1,
    [1] = {
        name = 'i',
        type = 'integer',
        line = 2,
        [1] = {
            type = 'integer',
            [1] = 0,
        },
    },
}

check[[
globals
    constant integer i = 0
endglobals
]]
{
    type = 'globals',
    line = 1,
    [1] = {
        name = 'i',
        type = 'integer',
        constant = true,
        line = 2,
        [1] = {
            type = 'integer',
            [1] = 0,
        },
    },
}

check[[
globals
    integer i
    boolean b
    integer array ai
    constant boolean cb
endglobals
]]
{
    type = 'globals',
    line = 1,
    [1] = {
        name = 'i',
        type = 'integer',
        line = 2,
    },
    [2] = {
        name = 'b',
        type = 'boolean',
        line = 3,
    },
    [3] = {
        name = 'ai',
        type = 'integer',
        array = true,
        line = 4,
    },
    [4] = {
        name = 'cb',
        type = 'boolean',
        constant = true,
        line = 5,
    },
}
