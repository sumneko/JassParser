local chunk
local jass

local function add_head()
    chunk[#chunk+1] = [[
local jass = require 'jass.common'
local mt = {}
]]
end

local function add_tail()
    chunk[#chunk+1] = [[

return mt
]]
end

local get_exp

local function get_string(exp)
    return ('%q'):format(exp[1])
end

local function get_boolean(exp)
    if exp[1] == true then
        return 'true'
    elseif exp[1] == false then
        return 'false'
    end
end

-- TODO: 区分局部变量
local function get_var(exp)
    local field
    if jass.globals[exp.name] then
        field = 'mt'
    else
        field = 'jass'
    end
    return ('%s.%s'):format(field, exp.name)
end

-- TODO: 区分局部变量
local function get_vari(exp)
    local field
    if jass.globals[exp.name] then
        field = 'mt'
    else
        field = 'jass'
    end
    return ('%s.%s[%d]'):format(field, exp.name, get_exp(exp[1]))
end

local function get_call(exp)
    local args = {}
    for i = 1, #exp do
        args[i] = get_exp(exp[i])
    end
    local field
    if jass.functions[exp.name] then
        field = 'mt'
    else
        field = 'jass'
    end
    return ('%s.%s(%s)'):format(field, exp.name, table.concat(args, ', '))
end

-- TODO: 对字符串拼接做特殊处理
local function get_plus(exp)
    return ('%s %s %s'):format(get_exp(exp[1]), exp.type, get_exp(exp[2]))
end

local function get_op2(exp)
    return ('%s %s %s'):format(get_exp(exp[1]), exp.type, get_exp(exp[2]))
end

function get_exp(exp)
    if not exp then
        return 'nil'
    end
    if exp.type == 'null' then
        return 'nil'
    elseif exp.type == 'integer' then
        return exp[1]
    elseif exp.type == 'real' then
        return exp[1]
    elseif exp.type == 'string' then
        return get_string(exp)
    elseif exp.type == 'boolean' then
        return get_boolean(exp)
    elseif exp.type == 'var' then
        return get_var(exp)
    elseif exp.type == 'vari' then
        return get_vari(exp)
    elseif exp.type == 'call' then
        return get_call(exp)
    elseif exp.type == '+' then
        return get_plus(exp)
    elseif exp.type == '-' then
        return get_op2(exp)
    elseif exp.type == '*' then
        return get_op2(exp)
    elseif exp.type == '/' then
        return get_op2(exp)
    end
    print(exp.type)
    return nil
end

local function add_globals()
    for _, global in ipairs(jass.globals) do
        chunk[#chunk+1] = ([[mt.%s = %s]]):format(global.name, get_exp(global[1]))
    end
end

return function (_jass)
    chunk = {}
    jass = _jass

    add_head()
    add_globals()
    add_tail()

    return table.concat(chunk, '\r\n')
end
