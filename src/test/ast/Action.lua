check 'call test()'
{
    type = 'call',
    name = 'test',
    file = 'war3map.j',
    line = 1,
}

check 'call test ()'
{
    type = 'call',
    name = 'test',
    file = 'war3map.j',
    line = 1,
}

check 'call test(1, 2, 3)'
{
    type = 'call',
    name = 'test',
    file = 'war3map.j',
    line = 1,
    [1] = {
        type = 'integer',
        vtype = 'integer',
        value = 1,
    },
    [2] = {
        type = 'integer',
        vtype = 'integer',
        value = 2,
    },
    [3] = {
        type = 'integer',
        vtype = 'integer',
        value = 3,
    },
}

check 'call test ( 1 , 2 , 3 )'
{
    type = 'call',
    name = 'test',
    file = 'war3map.j',
    line = 1,
    [1] = {
        type = 'integer',
        vtype = 'integer',
        value = 1,
    },
    [2] = {
        type = 'integer',
        vtype = 'integer',
        value = 2,
    },
    [3] = {
        type = 'integer',
        vtype = 'integer',
        value = 3,
    },
}

check 'call test(null)'
{
    type = 'call',
    name = 'test',
    file = 'war3map.j',
    line = 1,
    [1] = {
        type = 'null',
        vtype = 'null',
    },
}

check 'set x = 1'
{
    type = 'set',
    name = 'x',
    file = 'war3map.j',
    line = 1,
    [1] = {
        type = 'integer',
        vtype = 'integer',
        value = 1,
    },
}

check 'set x[5] = 1'
{
    type = 'seti',
    name = 'x',
    file = 'war3map.j',
    line = 1,
    [1] = {
        type = 'integer',
        vtype = 'integer',
        value = 5,
    },
    [2] = {
        type = 'integer',
        vtype = 'integer',
        value = 1,
    },
}

check 'return'
{
    type = 'return',
    file = 'war3map.j',
    line = 1,
}

check 'return 0'
{
    type = 'return',
    file = 'war3map.j',
    line = 1,
    [1] = {
        type = 'integer',
        vtype = 'integer',
        value = 0,
    },
}

check 'return (0)'
{
    type = 'return',
    file = 'war3map.j',
    line = 1,
    [1] = {
        type = 'integer',
        vtype = 'integer',
        value = 0,
    },
}

check 'return(0)'
{
    type = 'return',
    file = 'war3map.j',
    line = 1,
    [1] = {
        type = 'integer',
        vtype = 'integer',
        value = 0,
    },
}

check 'exitwhen true'
{
    type = 'exit',
    file = 'war3map.j',
    line = 1,
    [1] = {
        type = 'boolean',
        vtype = 'boolean',
        value = true,
    },
}

check 'exitwhen (true)'
{
    type = 'exit',
    file = 'war3map.j',
    line = 1,
    [1] = {
        type = 'boolean',
        vtype = 'boolean',
        value = true,
    },
}

check 'exitwhen(true)'
{
    type = 'exit',
    file = 'war3map.j',
    line = 1,
    [1] = {
        type = 'boolean',
        vtype = 'boolean',
        value = true,
    },
}

check [[
if true then
endif
]]
{
    type = 'if',
    file = 'war3map.j',
    line = 1,
    endline = 2,
    [1] = {
        type = 'if',
        file = 'war3map.j',
        line = 1,
        condition = {
            type = 'boolean',
            vtype = 'boolean',
            value = true,
        },
    },
}

check [[
if true then
    call test()
endif
]]
{
    type = 'if',
    file = 'war3map.j',
    line = 1,
    endline = 3,
    [1] = {
        type = 'if',
        file = 'war3map.j',
        line = 1,
        condition = {
            type = 'boolean',
            vtype = 'boolean',
            value = true,
        },
        [1] = {
            type = 'call',
            file = 'war3map.j',
            line = 2,
            name = 'test',
        },
    },
}

check [[
if true then
    set a = 1
elseif true then
    set a = 1
elseif true then
    set a = 1
else
    set a = 1
endif
]]
{
    type = 'if',
    file = 'war3map.j',
    line = 1,
    endline = 9,
    [1] = {
        type = 'if',
        file = 'war3map.j',
        line = 1,
        condition = {
            type = 'boolean',
            vtype = 'boolean',
            value = true,
        },
        [1] = {
            type = 'set',
            file = 'war3map.j',
            line = 2,
            name = 'a',
            [1] = {
                type = 'integer',
                vtype = 'integer',
                value = 1,
            }
        },
    },
    [2] = {
        type = 'elseif',
        file = 'war3map.j',
        line = 3,
        condition = {
            type = 'boolean',
            vtype = 'boolean',
            value = true,
        },
        [1] = {
            type = 'set',
            file = 'war3map.j',
            line = 4,
            name = 'a',
            [1] = {
                type = 'integer',
                vtype = 'integer',
                value = 1,
            }
        },
    },
    [3] = {
        type = 'elseif',
        file = 'war3map.j',
        line = 5,
        condition = {
            type = 'boolean',
            vtype = 'boolean',
            value = true,
        },
        [1] = {
            type = 'set',
            file = 'war3map.j',
            line = 6,
            name = 'a',
            [1] = {
                type = 'integer',
                vtype = 'integer',
                value = 1,
            }
        },
    },
    [4] = {
        type = 'else',
        file = 'war3map.j',
        line = 7,
        [1] = {
            type = 'set',
            file = 'war3map.j',
            line = 8,
            name = 'a',
            [1] = {
                type = 'integer',
                vtype = 'integer',
                value = 1,
            }
        },
    },
}

check [[
loop
endloop
]]
{
    type = 'loop',
    file = 'war3map.j',
    line = 1,
    endline = 2,
}

check [[
loop
    exitwhen true
endloop
]]
{
    type = 'loop',
    file = 'war3map.j',
    line = 1,
    endline = 3,
    [1] = {
        type = 'exit',
        file = 'war3map.j',
        line = 2,
        [1] = {
            type = 'boolean',
            vtype = 'boolean',
            value = true,
        },
    },
}

check [[
loop
    if true then
        exitwhen true
    endif
endloop
]]
{
    type = 'loop',
    file = 'war3map.j',
    line = 1,
    endline = 5,
    [1] = {
        type = 'if',
        file = 'war3map.j',
        line = 2,
        endline = 4,
        [1] = {
            type = 'if',
            file = 'war3map.j',
            line = 2,
            condition = {
                type = 'boolean',
                vtype = 'boolean',
                value = true,
            },
            [1] = {
                type = 'exit',
                file = 'war3map.j',
                line = 3,
                [1] = {
                    type = 'boolean',
                    vtype = 'boolean',
                    value = true,
                },
            },
        },
    },
}
