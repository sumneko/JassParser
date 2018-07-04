check '0'
{
    type = 'integer',
    value = 0,
}

check 'x'
{
    type = 'var',
    name = 'x',
}

check 'x[0]'
{
    type = 'vari',
    name = 'x',
    [1] = {
        type = 'integer',
        value = 0,
    }
}

check 'x[x[0]]'
{
    type = 'vari',
    name = 'x',
    [1] = {
        type = 'vari',
        name = 'x',
        [1] = {
            type = 'integer',
            value = 0,
        }
    }
}

check 'test()'
{
    type = 'call',
    name = 'test',
}

check 'test(x, y, z)'
{
    type = 'call',
    name = 'test',
    [1] = {
        type = 'var',
        name = 'x',
    },
    [2] = {
        type = 'var',
        name = 'y',
    },
    [3] = {
        type = 'var',
        name = 'z',
    },
}

check 'function test'
{
    type = 'code',
    name = 'test',
}

check '(1)'
{
    type = 'integer',
    value = 1,
}

check '((1))'
{
    type = 'integer',
    value = 1,
}

check 'not true'
{
    type = 'not',
    [1] = {
        type = 'boolean',
        value = true,
    },
}

check 'not not true'
{
    type = 'not',
    [1] = {
        type = 'not',
        [1] = {
            type = 'boolean',
            value = true,
        },
    },
}

check 'nottrue'
{
    type = 'var',
    name = 'nottrue',
}

check 'not (true)'
{
    type = 'not',
    [1] = {
        type = 'boolean',
        value = true,
    },
}

check 'not(true)'
{
    type = 'not',
    [1] = {
        type = 'boolean',
        value = true,
    },
}

check '- x'
{
    type = 'neg',
    [1] = {
        type = 'var',
        name = 'x',
    },
}

check '-x'
{
    type = 'neg',
    [1] = {
        type = 'var',
        name = 'x',
    },
}

check '1 * 1'
{
    type = '*',
    [1] = {
        type = 'integer',
        value = 1,
    },
    [2] = {
        type = 'integer',
        value = 1,
    },
}

check '1*1'
{
    type = '*',
    [1] = {
        type = 'integer',
        value = 1,
    },
    [2] = {
        type = 'integer',
        value = 1,
    },
}

check '1 * 1 / 1'
{
    type = '/',
    [1] = {
        type = '*',
        [1] = {
            type = 'integer',
            value = 1,
        },
        [2] = {
            type = 'integer',
            value = 1,
        },
    },
    [2] = {
        type = 'integer',
        value = 1,
    },
}

check '1 + 1'
{
    type = '+',
    [1] = {
        type = 'integer',
        value = 1,
    },
    [2] = {
        type = 'integer',
        value = 1,
    },
}

check '1 + 1 - 1'
{
    type = '-',
    [1] = {
        type = '+',
        [1] = {
            type = 'integer',
            value = 1,
        },
        [2] = {
            type = 'integer',
            value = 1,
        },
    },
    [2] = {
        type = 'integer',
        value = 1,
    },
}

check '1 * 1 + 1'
{
    type = '+',
    [1] = {
        type = '*',
        [1] = {
            type = 'integer',
            value = 1,
        },
        [2] = {
            type = 'integer',
            value = 1,
        },
    },
    [2] = {
        type = 'integer',
        value = 1,
    },
}

check '1 * (1 + 1)'
{
    type = '*',
    [1] = {
        type = 'integer',
        value = 1,
    },
    [2] = {
        type = '+',
        [1] = {
            type = 'integer',
            value = 1,
        },
        [2] = {
            type = 'integer',
            value = 1,
        },
    },
}

check '1 + 1 * 1'
{
    type = '+',
    [1] = {
        type = 'integer',
        value = 1,
    },
    [2] = {
        type = '*',
        [1] = {
            type = 'integer',
            value = 1,
        },
        [2] = {
            type = 'integer',
            value = 1,
        },
    },
}

check '(1 + 1) * 1'
{
    type = '*',
    [1] = {
        type = '+',
        [1] = {
            type = 'integer',
            value = 1,
        },
        [2] = {
            type = 'integer',
            value = 1,
        },
    },
    [2] = {
        type = 'integer',
        value = 1,
    },
}

check 'true == true'
{
    type = '==',
    [1] = {
        type = 'boolean',
        value = true,
    },
    [2] = {
        type = 'boolean',
        value = true,
    },
}

check 'true == true != true'
{
    type = '!=',
    [1] = {
        type = '==',
        [1] = {
            type = 'boolean',
            value = true,
        },
        [2] = {
            type = 'boolean',
            value = true,
        },
    },
    [2] = {
        type = 'boolean',
        value = true,
    },
}

check 'true == not true'
{
    type = '==',
    [1] = {
        type = 'boolean',
        value = true,
    },
    [2] = {
        type = 'not',
        [1] = {
            type = 'boolean',
            value = true,
        },
    },
}

check 'true and true'
{
    type = 'and',
    [1] = {
        type = 'boolean',
        value = true,
    },
    [2] = {
        type = 'boolean',
        value = true,
    },
}

check 'true and true == true'
{
    type = 'and',
    [1] = {
        type = 'boolean',
        value = true,
    },
    [2] = {
        type = '==',
        [1] = {
            type = 'boolean',
            value = true,
        },
        [2] = {
            type = 'boolean',
            value = true,
        },
    },
}

check 'true or true'
{
    type = 'or',
    [1] = {
        type = 'boolean',
        value = true,
    },
    [2] = {
        type = 'boolean',
        value = true,
    },
}

check 'true and true or true'
{
    type = 'and',
    [1] = {
        type = 'boolean',
        value = true,
    },
    [2] = {
        type = 'or',
        [1] = {
            type = 'boolean',
            value = true,
        },
        [2] = {
            type = 'boolean',
            value = true,
        },
    },
}
