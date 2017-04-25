local type = type
local pairs = pairs
local ipairs = ipairs
local table_concat = table.concat
local table_sort = table.sort

local lines
local tab

local function format_name(name)
    if type(name) == 'string' then
        return ('%q'):format(name)
    end
    return tostring(name)
end

local function write_value(key, value)
    lines[#lines+1] = ('%s[%s] = %s,'):format(('\t'):rep(tab), format_name(key), format_name(value))
end

local function write_table(name, tbl)
    if name then
        lines[#lines+1] = ('%s[%s] = {'):format(('\t'):rep(tab), format_name(name))
    else
        lines[#lines+1] = ('%s{'):format(('\t'):rep(tab))
    end
    tab = tab + 1
    local keys = {}
    for k in pairs(tbl) do
        keys[#keys+1] = k
    end
    table_sort(keys, function(a, b)
        if type(a) == type(b) then
            return a < b
        else
            return type(a) == 'string'
        end
    end)
    for _, key in ipairs(keys) do
        local value = tbl[key]
        if type(value) == 'table' then
            write_table(key, value)
        else
            write_value(key, value)
        end
    end
    tab = tab - 1
    lines[#lines+1] = ('%s},'):format(('\t'):rep(tab), name)
end

return function(tbl)
    lines = {}
    tab = 0
    write_table(nil, tbl)
    return table_concat(lines, '\r\n')
end
