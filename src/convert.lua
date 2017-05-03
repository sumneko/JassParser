local chunk
local jass

local current_function
local get_exp

local function add_head()
    chunk[#chunk+1] = [[
local jass = require 'jass.common'
local japi = require 'jass.japi'

local mt = {}
]]
end

local function add_tail()
    chunk[#chunk+1] = [[

return mt
]]
end

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
-- TODO: 部分类型要有默认值
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
    for i, sub_exp in ipairs(exp) do
        args[i] = get_exp(sub_exp)
    end
    local field
    if jass.functions[exp.name] then
        field = 'mt'
    elseif jass.natives[exp.name] then
        field = 'japi'
    else
        field = 'jass'
    end
    return ('%s.%s(%s)'):format(field, exp.name, table.concat(args, ', '))
end

-- TODO: 对字符串拼接做特殊处理
local function get_add(exp)
    return ('%s + %s'):format(get_exp(exp[1]), get_exp(exp[2]))
end

local function get_sub(exp)
    return ('%s - %s'):format(get_exp(exp[1]), get_exp(exp[2]))
end

local function get_mul(exp)
    return ('%s * %s'):format(get_exp(exp[1]), get_exp(exp[2]))
end

-- TODO: 对整数除法做特殊处理
local function get_div(exp)
    return ('%s / %s'):format(get_exp(exp[1]), get_exp(exp[2]))
end

function get_exp(exp)
    if not exp then
        return nil
    end
    if exp.type == 'null' then
        return nil
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
        return get_add(exp)
    elseif exp.type == '-' then
        return get_sub(exp)
    elseif exp.type == '*' then
        return get_mul(exp)
    elseif exp.type == '/' then
        return get_div(exp)
    end
    print(exp.type)
    return nil
end

local function add_global(global)
    local value = get_exp(global[1])
    if global.array and not value then
        value = '{}'
    end
    if not value then
        return
    end
    chunk[#chunk+1] = ([[mt.%s = %s]]):format(global.name, value)
end

local function add_globals()
    for _, global in ipairs(jass.globals) do
        add_global(global)
    end
end

local function add_function(func)
    current_function = func
    if func.native then
        return
    end
    local args = {}
    if func.args then
        for i, arg in ipairs(func.args) do
            args[i] = arg.name
        end
    end
    chunk[#chunk+1] = ([[function mt.%s(%s)]]):format(func.name, table.concat(args, ', '))
    chunk[#chunk+1] = 'end'
end

local function add_functions()
    for _, func in ipairs(jass.functions) do
        add_function(func)
    end
end

local function special()
    jass.natives.SetUnitState     = true
    jass.natives.InitGameCache    = true
    jass.natives.SaveGameCache    = true
    jass.natives.StoreInteger     = true
    jass.natives.GetStoredInteger = true
    jass.natives.FlushGameCache   = true
end

return function (_jass)
    chunk = {}
    jass = _jass

    special()

    add_head()
    add_globals()
    add_functions()
    add_tail()

    return table.concat(chunk, '\r\n')
end
