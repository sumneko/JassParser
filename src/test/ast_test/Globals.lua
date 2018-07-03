check[[
globals
endglobals
]]
{
    type = 'globals',
    file = 'war3map.j',
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
    file = 'war3map.j',
    line = 1,
}

check[[
globals
    integer i
endglobals
]]
{
    type = 'globals',
    file = 'war3map.j',
    line = 1,
    [1] = {
        name = 'i',
        type = 'integer',
        file = 'war3map.j',
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
    file    = 'war3map.j',
    line = 1,
    [1] = {
        name = 'b',
        type = 'boolean',
        array = true,
        file = 'war3map.j',
        line = 2,
    },
}

check[[
globals
    constant integer ci = 0
endglobals
]]
{
    type = 'globals',
    file    = 'war3map.j',
    line = 1,
    [1] = {
        name = 'ci',
        type = 'integer',
        constant = true,
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
globals
    boolean array b
endglobals
]]
{
    type = 'globals',
    file    = 'war3map.j',
    line = 1,
    [1] = {
        name = 'b',
        type = 'boolean',
        array = true,
        file = 'war3map.j',
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
    file = 'war3map.j',
    line = 1,
    [1] = {
        name = 'i',
        type = 'integer',
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
globals
    constant integer i = 0
endglobals
]]
{
    type = 'globals',
    file = 'war3map.j',
    line = 1,
    [1] = {
        name = 'i',
        type = 'integer',
        constant = true,
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
globals
    integer i
    boolean b
    integer array ai
    constant boolean cb = false
endglobals
]]
{
    type = 'globals',
    file = 'war3map.j',
    line = 1,
    [1] = {
        name = 'i',
        type = 'integer',
        file = 'war3map.j',
        line = 2,
    },
    [2] = {
        name = 'b',
        type = 'boolean',
        file = 'war3map.j',
        line = 3,
    },
    [3] = {
        name = 'ai',
        type = 'integer',
        array = true,
        file = 'war3map.j',
        line = 4,
    },
    [4] = {
        name = 'cb',
        type = 'boolean',
        constant = true,
        file = 'war3map.j',
        line = 5,
        [1] = {
            type = 'boolean',
            value = false,
            vtype = 'boolean',
        },
    },
}
