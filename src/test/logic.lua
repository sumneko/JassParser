check[[
function test takes nothing returns nothing
    if true then
    endif
endfunction
]]
{
    type = 'function',
    name = 'test',
    file = 'war3map.j',
    line = 1,
    locals = {},
    [1] = {
        type = 'if',
        file = 'war3map.j',
        line = 2,
        [1] = {
            type = 'if',
            file = 'war3map.j',
            line = 2,
            condition = {
                type = 'boolean',
                value = true,
                vtype = 'boolean',
            },
        },
    },
}

check[[
function test takes nothing returns nothing
    if true then
        call test()
    endif
endfunction
]]
{
    type = 'function',
    name = 'test',
    file = 'war3map.j',
    line = 1,
    locals = {},
    [1] = {
        type = 'if',
        file = 'war3map.j',
        line = 2,
        [1] = {
            type = 'if',
            file = 'war3map.j',
            line = 2,
            condition = {
                type = 'boolean',
                value = true,
                vtype = 'boolean',
            },
            [1] = {
                type = 'call',
                name = 'test',
                file = 'war3map.j',
                line = 3,
            },
        },
    },
}

check[[
function test takes nothing returns nothing
    local integer a
    if true then
        set a = 1
    elseif true then
        set a = 1
    elseif true then
        set a = 1
    else
        set a = 1
    endif
endfunction
]]
{
    type = 'function',
    name = 'test',
    file = 'war3map.j',
    line = 1,
    locals = {
        [1] = {
            type = 'integer',
            name = 'a',
            file = 'war3map.j',
            line = 2,
        },
        a = {
            type = 'integer',
            name = 'a',
            file = 'war3map.j',
            line = 2,
        },
    },
    [1] = {
        type = 'if',
        file = 'war3map.j',
        line = 3,
        [1] = {
            type = 'if',
            file = 'war3map.j',
            line = 3,
            condition = {
                type = 'boolean',
                value = true,
                vtype = 'boolean',
            },
            [1] = {
                type = 'set',
                name = 'a',
                file = 'war3map.j',
                line = 4,
                [1] = {
                    type = 'integer',
                    value = 1,
                    vtype = 'integer',
                },
            },
        },
        [2] = {
            type = 'elseif',
            file = 'war3map.j',
            line = 5,
            condition = {
                type = 'boolean',
                value = true,
                vtype = 'boolean',
            },
            [1] = {
                type = 'set',
                name = 'a',
                file = 'war3map.j',
                line = 6,
                [1] = {
                    type = 'integer',
                    value = 1,
                    vtype = 'integer',
                },
            },
        },
        [3] = {
            type = 'elseif',
            file = 'war3map.j',
            line = 7,
            condition = {
                type = 'boolean',
                value = true,
                vtype = 'boolean',
            },
            [1] = {
                type = 'set',
                name = 'a',
                file = 'war3map.j',
                line = 8,
                [1] = {
                    type = 'integer',
                    value = 1,
                    vtype = 'integer',
                },
            },
        },
        [4] = {
            type = 'else',
            file = 'war3map.j',
            line = 9,
            [1] = {
                type = 'set',
                name = 'a',
                file = 'war3map.j',
                line = 10,
                [1] = {
                    type = 'integer',
                    value = 1,
                    vtype = 'integer',
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
    file = 'war3map.j',
    line = 1,
    locals = {},
    [1] = {
        type = 'loop',
        file = 'war3map.j',
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
    file = 'war3map.j',
    line = 1,
    locals = {},
    [1] = {
        type = 'loop',
        file = 'war3map.j',
        line = 2,
        [1] = {
            type = 'exit',
            file = 'war3map.j',
            line = 3,
            [1] = {
                type = 'boolean',
                value = true,
                vtype = 'boolean',
            },
        },
    },
}

check[[
function test takes nothing returns nothing
    loop
        if true then
            exitwhen true
        endif
    endloop
endfunction
]]
{
    type = 'function',
    name = 'test',
    file = 'war3map.j',
    line = 1,
    locals = {},
    [1] = {
        type = 'loop',
        file = 'war3map.j',
        line = 2,
        [1] = {
            type = 'if',
            file = 'war3map.j',
            line = 3,
            [1] = {
                type = 'if',
                file = 'war3map.j',
                line = 3,
                condition = {
                    type = 'boolean',
                    value = true,
                    vtype = 'boolean',
                },
                [1] = {
                    type = 'exit',
                    file = 'war3map.j',
                    line = 4,
                    [1] = {
                        type = 'boolean',
                        value = true,
                        vtype = 'boolean',
                    },
                },
            },
        },
    },
}

