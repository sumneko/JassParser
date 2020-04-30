check '1'
{
    type = 'integer',
    vtype = 'integer',
    value = 1,
}
check '-1'
{
    type = 'integer',
    vtype = 'integer',
    value = -1,
}
check '- 1'
{
    type = 'integer',
    vtype = 'integer',
    value = -1,
}
check '$A'
{
    type = 'integer',
    vtype = 'integer',
    value = 10,
}
check '-$A'
{
    type = 'integer',
    vtype = 'integer',
    value = -10,
}
check '- $A'
{
    type = 'integer',
    vtype = 'integer',
    value = -10,
}
check '0x10'
{
    type = 'integer',
    vtype = 'integer',
    value = 16,
}
check '-0x10'
{
    type = 'integer',
    vtype = 'integer',
    value = -16,
}
check '- 0x10'
{
    type = 'integer',
    vtype = 'integer',
    value = -16,
}
check '010'
{
    type = 'integer',
    vtype = 'integer',
    value = 8,
}
check '-010'
{
    type = 'integer',
    vtype = 'integer',
    value = -8,
}
check '- 010'
{
    type = 'integer',
    vtype = 'integer',
    value = -8,
}
check "'A'"
{
    type = 'integer',
    vtype = 'integer',
    value = 65,
}
check "-'A'"
{
    type = 'integer',
    vtype = 'integer',
    value = -65,
}
check "- 'A'"
{
    type = 'integer',
    vtype = 'integer',
    value = -65,
}
check "'Aloc'"
{
    type = 'integer',
    vtype = 'integer',
    value = 1097625443,
}
check '1.0'
{
    type = 'real',
    vtype = 'real',
    value = '1.0',
}
check '1.'
{
    type = 'real',
    vtype = 'real',
    value = '1.',
}
check '.1'
{
    type = 'real',
    vtype = 'real',
    value = '.1',
}
check '-1.0'
{
    type = 'real',
    vtype = 'real',
    value = '-1.0',
}
check '-1.'
{
    type = 'real',
    vtype = 'real',
    value = '-1.',
}
check '-.1'
{
    type = 'real',
    vtype = 'real',
    value = '-.1',
}
check '- 1.0'
{
    type = 'real',
    vtype = 'real',
    value = '- 1.0',
}
check '- 1.'
{
    type = 'real',
    vtype = 'real',
    value = '- 1.',
}
check '- .1'
{
    type = 'real',
    vtype = 'real',
    value = '- .1',
}
check '0.999999999'
{
    type = 'real',
    vtype = 'real',
    value = '0.999999999',
}
check 'true'
{
    type = 'boolean',
    vtype = 'boolean',
    value = true,
}
check 'false'
{
    type = 'boolean',
    vtype = 'boolean',
    value = false,
}
check 'null'
{
    type = 'null',
    vtype = 'null',
}
check '"1"'
{
    type = 'string',
    vtype = 'string',
    value = '1',
}
check [["1\"\\\b\t\r\n\f"]]
{
    type = 'string',
    vtype = 'string',
    value = [[1\"\\\b\t\r\n\f]],
}
check [[2222222222222222222222222222222]]
{
    type = 'integer',
    vtype = 'integer',
    value = 2147483647,
}
check [[0xffffffff]]
{
    type = 'integer',
    vtype = 'integer',
    value = 4294967295,
}
