check ''
{}

check [[

]]
{}

check [[
type loli extends unit
]]
{
    [1] = {
        type    = 'type',
        file    = 'war3map.j',
        line    = 1,
        name    = 'loli',
        extends = 'unit',
    },
}

check [[
type loli extends unit]]
{
    [1] = {
        type    = 'type',
        file    = 'war3map.j',
        line    = 1,
        name    = 'loli',
        extends = 'unit',
    },
}

check [[

type loli extends unit]]
{
    [1] = {
        type    = 'type',
        file    = 'war3map.j',
        line    = 2,
        name    = 'loli',
        extends = 'unit',
    },
}

check [[

type loli extends unit
]]
{
    [1] = {
        type    = 'type',
        file    = 'war3map.j',
        line    = 2,
        name    = 'loli',
        extends = 'unit',
    },
}

check [[
type loli extends handle
type JS   extends loli

globals
    loli mine
    JS   alsomine
endglobals

constant native school takes loli who  returns JS
constant native prpr   takes JS   wife returns loli

function H takes loli who returns loli
    local JS   wife     = school(who) // The teacher is me
    local loli daughter = prpr(wife)
    return daughter
endfunction

// Never has chance to H with loli
]]
{
    [1] = {
        type    = 'type',
        file    = 'war3map.j',
        line    = 1,
        name    = 'loli',
        extends = 'handle',
    },
    [2] = {
        type    = 'type',
        file    = 'war3map.j',
        line    = 2,
        name    = 'JS',
        extends = 'loli',
    },
    [3] = {
        type = 'globals',
        file = 'war3map.j',
        line = 4,
        [1]  = {
            name = 'mine',
            type = 'loli',
            vtype = 'loli',
            file = 'war3map.j',
            line = 5,
        },
        [2]  = {
            name = 'alsomine',
            type = 'JS',
            vtype = 'JS',
            file = 'war3map.j',
            line = 6,
        },
    },
    [4] = {
        type = 'function',
        name = 'school',
        file = 'war3map.j',
        line = 9,
        native = true,
        constant = true,
        returns = 'JS',
        args = {
            [1] = {
                type = 'loli',
                vtype = 'loli',
                name = 'who',
            },
        },
    },
    [5] = {
        type = 'function',
        name = 'prpr',
        file = 'war3map.j',
        line = 10,
        native = true,
        constant = true,
        returns = 'loli',
        args = {
            [1] = {
                type = 'JS',
                vtype = 'JS',
                name = 'wife',
            },
        },
    },
    [6] = {
        type = 'function',
        name = 'H',
        file = 'war3map.j',
        line = 12,
        endline = 16,
        returns = 'loli',
        args = {
            [1] = {
                type = 'loli',
                vtype = 'loli',
                name = 'who',
            },
        },
        locals = {
            [1] = {
                type = 'JS',
                vtype = 'JS',
                name = 'wife',
                file = 'war3map.j',
                line = 13,
                [1] = {
                    type = 'call',
                    name = 'school',
                    [1] = {
                        type = 'var',
                        vtype = 'loli',
                        name = 'who',
                    },
                },
            },
            [2] = {
                type = 'loli',
                vtype = 'loli',
                name = 'daughter',
                file = 'war3map.j',
                line = 14,
                [1] = {
                    type = 'call',
                    name = 'prpr',
                    [1] = {
                        type = 'var',
                        vtype = 'JS',
                        name = 'wife',
                    },
                },
            },
        },
        [1] = {
            type = 'return',
            file = 'war3map.j',
            line = 15,
            [1] = {
                type = 'var',
                vtype = 'loli',
                name = 'daughter',
            },
        },
    },
}
{
    [13] = ' The teacher is me',
    [18] = ' Never has chance to H with loli',
}
