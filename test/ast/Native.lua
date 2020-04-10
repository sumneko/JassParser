check 'native test takes nothing returns nothing'
{
    type = 'function',
    name = 'test',
    file = 'war3map.j',
    line = 1,
    native = true,
    returns = "nothing",
    vtype = 'nothing',
}

check 'constant native test takes nothing returns nothing'
{
    type = 'function',
    name = 'test',
    file = 'war3map.j',
    line = 1,
    native = true,
    constant = true,
    returns = "nothing",
    vtype = 'nothing',
}

check 'native test takes nothing returns boolean'
{
    type = 'function',
    vtype = 'boolean',
    name = 'test',
    file = 'war3map.j',
    line = 1,
    native = true,
    returns = 'boolean',
}

check 'native test takes integer x returns nothing'
{
    type = 'function',
    name = 'test',
    file = 'war3map.j',
    line = 1,
    native = true,
    returns = "nothing",
    vtype = 'nothing',
    args = {
        [1] = {
            type = 'integer',
            vtype = 'integer',
            name = 'x',
        },
    },
}

check 'native test takes integer x, integer y, integer z returns nothing'
{
    type = 'function',
    name = 'test',
    file = 'war3map.j',
    line = 1,
    native = true,
    returns = "nothing",
    vtype = 'nothing',
    args = {
        [1] = {
            type = 'integer',
            vtype = 'integer',
            name = 'x',
        },
        [2] = {
            type = 'integer',
            vtype = 'integer',
            name = 'y',
        },
        [3] = {
            type = 'integer',
            vtype = 'integer',
            name = 'z',
        },
    },
}
