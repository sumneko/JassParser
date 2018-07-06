check '1'
{
    type = 'integer',
    value = 1,
}
check '-1'
{
    type = 'integer',
    value = -1,
}
check '- 1'
{
    type = 'integer',
    value = -1,
}
check '$A'
{
    type = 'integer',
    value = 10,
}
check '-$A'
{
    type = 'integer',
    value = -10,
}
check '- $A'
{
    type = 'integer',
    value = -10,
}
check '0x10'
{
    type = 'integer',
    value = 16,
}
check '-0x10'
{
    type = 'integer',
    value = -16,
}
check '- 0x10'
{
    type = 'integer',
    value = -16,
}
check "'A'"
{
    type = 'integer',
    value = 65,
}
check "-'A'"
{
    type = 'integer',
    value = -65,
}
check "- 'A'"
{
    type = 'integer',
    value = -65,
}
check "'Aloc'"
{
    type = 'integer',
    value = 1097625443,
}
check '1.0'
{
    type = 'real',
    value = '1.0',
}
check '1.'
{
    type = 'real',
    value = '1.',
}
check '.1'
{
    type = 'real',
    value = '.1',
}
check '-1.0'
{
    type = 'real',
    value = '-1.0',
}
check '-1.'
{
    type = 'real',
    value = '-1.',
}
check '-.1'
{
    type = 'real',
    value = '-.1',
}
check '- 1.0'
{
    type = 'real',
    value = '- 1.0',
}
check '- 1.'
{
    type = 'real',
    value = '- 1.',
}
check '- .1'
{
    type = 'real',
    value = '- .1',
}
check '0.999999999'
{
    type = 'real',
    value = '0.999999999',
}
check 'true'
{
    type = 'boolean',
    value = 'true',
}
check 'false'
{
    type = 'boolean',
    value = 'false',
}
check 'null'
{
    type = 'null',
}
check '"1"'
{
    type = 'string',
    value = '1',
}
check [["1\"\\\b\t\r\n\f"]]
{
    type = 'string',
    value = [[1\"\\\b\t\r\n\f]],
}
