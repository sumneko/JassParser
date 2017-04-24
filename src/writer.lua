local type = type
local pairs = pairs
local ipairs = ipairs
local table_concat = table.concat
local table_sort = table.sort

local lines
local tab

local function write_value(key, value)
    lines[#lines+1] = ('%s[%q] = %q,'):format(('\t'):rep(tab), key, value)
end

local function write_table(name, tbl)
    lines[#lines+1] = ('%s[%q] = {'):format(('\t'):rep(tab), name)
    tab = tab + 1
    local keys = {}
    for k in pairs(tbl) do
        keys[#keys+1] = k
    end
    table_sort(keys)
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

return function(name, tbl)
    lines = {}
    tab = 0
    write_table(name, tbl)
    return table_concat(lines, '\r\n')
end
