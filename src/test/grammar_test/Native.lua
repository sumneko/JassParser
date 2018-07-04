check 'native test takes nothing returns nothing'
{
    type = 'function',
    name = 'test',
    file = 'war3map.j',
    line = 1,
    native = true,
}

check 'constant native test takes nothing returns nothing'
{
    type = 'function',
    name = 'test',
    file = 'war3map.j',
    line = 1,
    native = true,
    constant = true,
}

check 'native test takes nothing returns boolean'
{
    type = 'function',
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
    args = {
        [1] = {
            type = 'integer',
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
    args = {
        [1] = {
            type = 'integer',
            name = 'x',
        },
        [2] = {
            type = 'integer',
            name = 'y',
        },
        [3] = {
            type = 'integer',
            name = 'z',
        },
    },
}
