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
        vtype = 'integer',
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
    file = 'war3map.j',
    line = 1,
    [1] = {
        name = 'b',
        type = 'boolean',
        vtype = 'boolean',
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
        vtype = 'integer',
        file = 'war3map.j',
        line = 2,
        [1] = {
            type = 'integer',
            vtype = 'integer',
            value = 0,
        },
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
        vtype = 'integer',
        constant = true,
        file = 'war3map.j',
        line = 2,
        [1] = {
            type = 'integer',
            vtype = 'integer',
            value = 0,
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
        vtype = 'integer',
        file = 'war3map.j',
        line = 2,
    },
    [2] = {
        name = 'b',
        type = 'boolean',
        vtype = 'boolean',
        file = 'war3map.j',
        line = 3,
    },
    [3] = {
        name = 'ai',
        type = 'integer',
        vtype = 'integer',
        array = true,
        file = 'war3map.j',
        line = 4,
    },
    [4] = {
        name = 'cb',
        type = 'boolean',
        vtype = 'boolean',
        constant = true,
        file = 'war3map.j',
        line = 5,
        [1] = {
            type = 'boolean',
            vtype = 'boolean',
            value = false,
        },
    },
}
