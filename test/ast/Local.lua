check 'local unit u'
{
    type = 'unit',
    vtype = 'unit',
    name = 'u',
    file = 'war3map.j',
    line = 1,
}

check 'local integer a = 1'
{
    type = 'integer',
    vtype = 'integer',
    name = 'a',
    file = 'war3map.j',
    line = 1,
    [1]  = {
        type = 'integer',
        vtype = 'integer',
        value = 1,
    }
}

check 'local integer array a'
{
    type = 'integer',
    vtype = 'integer',
    name = 'a',
    array = true,
    file = 'war3map.j',
    line = 1,
}
