check '0'
{
    type = 'integer',
    vtype = 'integer',
    value = 0,
}

check 'x'
{
    type = 'var',
    vtype = nil,
    name = 'x',
}

check 'x[0]'
{
    type = 'vari',
    vtype = nil,
    name = 'x',
    [1] = {
        type = 'integer',
        vtype = 'integer',
        value = 0,
    }
}

check 'x[x[0]]'
{
    type = 'vari',
    vtype = nil,
    name = 'x',
    [1] = {
        type = 'vari',
        vtype = nil,
        name = 'x',
        [1] = {
            type = 'integer',
            vtype = 'integer',
            value = 0,
        }
    }
}

check 'test()'
{
    type = 'call',
    vtype = nil,
    name = 'test',
}

check 'test(x, y, z)'
{
    type = 'call',
    vtype = nil,
    name = 'test',
    [1] = {
        type = 'var',
        vtype = nil,
        name = 'x',
    },
    [2] = {
        type = 'var',
        vtype = nil,
        name = 'y',
    },
    [3] = {
        type = 'var',
        vtype = nil,
        name = 'z',
    },
}

check 'function test'
{
    type = 'code',
    vtype = 'code',
    name = 'test',
}

check '(1)'
{
    type = 'integer',
    vtype = 'integer',
    value = 1,
}

check '((1))'
{
    type = 'integer',
    vtype = 'integer',
    value = 1,
}

check 'not true'
{
    type = 'not',
    vtype = 'boolean',
    [1] = {
        type = 'boolean',
        vtype = 'boolean',
        value = true,
    },
}

check 'not not true'
{
    type = 'not',
    vtype = 'boolean',
    [1] = {
        type = 'not',
        vtype = 'boolean',
        [1] = {
            type = 'boolean',
            vtype = 'boolean',
            value = true,
        },
    },
}

check 'nottrue'
{
    type = 'var',
    vtype = nil,
    name = 'nottrue',
}

check 'not (true)'
{
    type = 'not',
    vtype = 'boolean',
    [1] = {
        type = 'boolean',
        vtype = 'boolean',
        value = true,
    },
}

check 'not(true)'
{
    type = 'not',
    vtype = 'boolean',
    [1] = {
        type = 'boolean',
        vtype = 'boolean',
        value = true,
    },
}

check '- x'
{
    type = 'neg',
    vtype = nil,
    [1] = {
        type = 'var',
        vtype = nil,
        name = 'x',
    },
}

check '-x'
{
    type = 'neg',
    vtype = nil,
    [1] = {
        type = 'var',
        vtype = nil,
        name = 'x',
    },
}

check '1 * 1'
{
    type = '*',
    vtype = 'integer',
    [1] = {
        type = 'integer',
        vtype = 'integer',
        value = 1,
    },
    [2] = {
        type = 'integer',
        vtype = 'integer',
        value = 1,
    },
}

check '1*1'
{
    type = '*',
    vtype = 'integer',
    [1] = {
        type = 'integer',
        vtype = 'integer',
        value = 1,
    },
    [2] = {
        type = 'integer',
        vtype = 'integer',
        value = 1,
    },
}

check '1 * 1 / 1'
{
    type = '/',
    vtype = 'integer',
    [1] = {
        type = '*',
        vtype = 'integer',
        [1] = {
            type = 'integer',
            vtype = 'integer',
            value = 1,
        },
        [2] = {
            type = 'integer',
            vtype = 'integer',
            value = 1,
        },
    },
    [2] = {
        type = 'integer',
        vtype = 'integer',
        value = 1,
    },
}

check '1 + 1'
{
    type = '+',
    vtype = 'integer',
    [1] = {
        type = 'integer',
        vtype = 'integer',
        value = 1,
    },
    [2] = {
        type = 'integer',
        vtype = 'integer',
        value = 1,
    },
}

check '1 + 1 - 1'
{
    type = '-',
    vtype = 'integer',
    [1] = {
        type = '+',
        vtype = 'integer',
        [1] = {
            type = 'integer',
            vtype = 'integer',
            value = 1,
        },
        [2] = {
            type = 'integer',
            vtype = 'integer',
            value = 1,
        },
    },
    [2] = {
        type = 'integer',
        vtype = 'integer',
        value = 1,
    },
}

check '1 * 1 + 1'
{
    type = '+',
    vtype = 'integer',
    [1] = {
        type = '*',
        vtype = 'integer',
        [1] = {
            type = 'integer',
            vtype = 'integer',
            value = 1,
        },
        [2] = {
            type = 'integer',
            vtype = 'integer',
            value = 1,
        },
    },
    [2] = {
        type = 'integer',
        vtype = 'integer',
        value = 1,
    },
}

check '1 * (1 + 1)'
{
    type = '*',
    vtype = 'integer',
    [1] = {
        type = 'integer',
        vtype = 'integer',
        value = 1,
    },
    [2] = {
        type = '+',
        vtype = 'integer',
        [1] = {
            type = 'integer',
            vtype = 'integer',
            value = 1,
        },
        [2] = {
            type = 'integer',
            vtype = 'integer',
            value = 1,
        },
    },
}

check '1 + 1 * 1'
{
    type = '+',
    vtype = 'integer',
    [1] = {
        type = 'integer',
        vtype = 'integer',
        value = 1,
    },
    [2] = {
        type = '*',
        vtype = 'integer',
        [1] = {
            type = 'integer',
            vtype = 'integer',
            value = 1,
        },
        [2] = {
            type = 'integer',
            vtype = 'integer',
            value = 1,
        },
    },
}

check '(1 + 1) * 1'
{
    type = '*',
    vtype = 'integer',
    [1] = {
        type = '+',
        vtype = 'integer',
        [1] = {
            type = 'integer',
            vtype = 'integer',
            value = 1,
        },
        [2] = {
            type = 'integer',
            vtype = 'integer',
            value = 1,
        },
    },
    [2] = {
        type = 'integer',
        vtype = 'integer',
        value = 1,
    },
}

check 'true == true'
{
    type = '==',
    vtype = 'boolean',
    [1] = {
        type = 'boolean',
        vtype = 'boolean',
        value = true,
    },
    [2] = {
        type = 'boolean',
        vtype = 'boolean',
        value = true,
    },
}

check 'true == true != true'
{
    type = '!=',
    vtype = 'boolean',
    [1] = {
        type = '==',
        vtype = 'boolean',
        [1] = {
            type = 'boolean',
            vtype = 'boolean',
            value = true,
        },
        [2] = {
            type = 'boolean',
            vtype = 'boolean',
            value = true,
        },
    },
    [2] = {
        type = 'boolean',
        vtype = 'boolean',
        value = true,
    },
}

check 'true == not true'
{
    type = '==',
    vtype = 'boolean',
    [1] = {
        type = 'boolean',
        vtype = 'boolean',
        value = true,
    },
    [2] = {
        type = 'not',
        vtype = 'boolean',
        [1] = {
            type = 'boolean',
            vtype = 'boolean',
            value = true,
        },
    },
}

check 'true and true'
{
    type = 'and',
    vtype = 'boolean',
    [1] = {
        type = 'boolean',
        vtype = 'boolean',
        value = true,
    },
    [2] = {
        type = 'boolean',
        vtype = 'boolean',
        value = true,
    },
}

check 'true and true == true'
{
    type = 'and',
    vtype = 'boolean',
    [1] = {
        type = 'boolean',
        vtype = 'boolean',
        value = true,
    },
    [2] = {
        type = '==',
        vtype = 'boolean',
        [1] = {
            type = 'boolean',
            vtype = 'boolean',
            value = true,
        },
        [2] = {
            type = 'boolean',
            vtype = 'boolean',
            value = true,
        },
    },
}

check 'true or true'
{
    type = 'or',
    vtype = 'boolean',
    [1] = {
        type = 'boolean',
        vtype = 'boolean',
        value = true,
    },
    [2] = {
        type = 'boolean',
        vtype = 'boolean',
        value = true,
    },
}

check 'true and true or true'
{
    type = 'and',
    vtype = 'boolean',
    [1] = {
        type = 'boolean',
        vtype = 'boolean',
        value = true,
    },
    [2] = {
        type = 'or',
        vtype = 'boolean',
        [1] = {
            type = 'boolean',
            vtype = 'boolean',
            value = true,
        },
        [2] = {
            type = 'boolean',
            vtype = 'boolean',
            value = true,
        },
    },
}
