check[[
globals
endglobals
]]
{
    type = 'globals',
}

check[[
globals
endglobals
globals
endglobals
]]
{
    type = 'globals',
}

check[[
globals
    integer i
endglobals
]]
{
    type = 'globals',
    [1] = {
        name = 'i',
        type = 'integer',
    },
}

check[[
globals
    boolean array b
endglobals
]]
{
    type = 'globals',
    [1] = {
        name = 'b',
        type = 'boolean',
        array = true,
    },
}

check[[
globals
    constant integer ci
endglobals
]]
{
    type = 'globals',
    [1] = {
        name = 'ci',
        type = 'integer',
        constant = true,
    },
}

check[[
globals
    constant boolean array b
endglobals
]]
{
    type = 'globals',
    [1] = {
        name = 'b',
        type = 'boolean',
        array = true,
        constant = true,
    },
}

check[[
globals
    integer i = 0
endglobals
]]
{
    type = 'globals',
    [1] = {
        name = 'i',
        type = 'integer',
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
    [1] = {
        name = 'i',
        type = 'integer',
        constant = true,
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
    [1] = {
        name = 'i',
        type = 'integer',
    },
    [2] = {
        name = 'b',
        type = 'boolean',
    },
    [3] = {
        name = 'ai',
        type = 'integer',
        array = true,
    },
    [4] = {
        name = 'cb',
        type = 'boolean',
        constant = true
    },
}
