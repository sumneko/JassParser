local chunk
local jass
local file

local current_function
local get_exp

local function add_head()
    chunk[#chunk+1] = [[
local jass = require 'jass.common'
local japi = require 'jass.japi'

local mt_array = {}
function mt_array:__index(i)
    if i < 0 or i > 8191 then
        error('数组索引越界:'..i)
    end
    return self._default
end

function mt_array:__newindex(i, v)
    if i < 0 or i > 8191 then
        error('数组索引越界:'..i)
    end
    rawset(self, i, v)
end

local function new_array(default)
    return setmetatable({ _default = default }, mt_array)
end

local mt = {}
]]
end

local function add_tail()
    chunk[#chunk+1] = [[

return mt
]]
end

local function get_string(exp)
    return ('%q'):format(exp.value)
end

local function get_boolean(exp)
    if exp.value == true then
        return 'true'
    elseif exp.value == false then
        return 'false'
    end
end

local function get_var_name(name)
    local field
    if jass.globals[name] then
        if jass.globals[name].file == 'common.j' then
            field = 'jass'
        elseif jass.globals[name].file == file then
            field = 'mt'
        else
            field = 'bj'
        end
    else
        field = 'loc'
    end
    return ('%s.%s'):format(field, name)
end

local function get_var(exp)
    return get_var_name(exp.name)
end

local function get_vari(exp)
    return ('%s[%s]'):format(get_var_name(exp.name), get_exp(exp[1]))
end

local function get_function_name(name)
    local field
    local func = jass.functions[name]
    if func.file == 'common.j' then
        field = 'jass'
    elseif func.file == file then
        if func.native then
            field = 'japi'
        else
            field = 'mt'
        end
    else
        if func.native then
            field = 'japi'
        else
            field = 'bj'
        end
    end
    return ('%s.%s'):format(field, name)
end

local function get_call(exp)
    local args = {}
    for i, sub_exp in ipairs(exp) do
        args[i] = get_exp(sub_exp)
    end
    return ('%s(%s)'):format(get_function_name(exp.name), table.concat(args, ', '))
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

local function get_neg(exp)
    return (' - %s'):format(get_exp(exp[1]))
end

local function get_paren(exp)
    return ('(%s)'):format(get_exp(exp[1]))
end

local function get_equal(exp)
    return ('%s == %s'):format(get_exp(exp[1]), get_exp(exp[2]))
end

local function get_function(exp)
    return get_function_name(exp.name)
end

function get_exp(exp)
    if not exp then
        return nil
    end
    if exp.type == 'null' then
        return nil
    elseif exp.type == 'integer' then
        return exp.value
    elseif exp.type == 'real' then
        return exp.value
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
    elseif exp.type == 'neg' then
        return get_neg(exp)
    elseif exp.type == 'paren' then
        return get_paren(exp)
    elseif exp.type == '==' then
        return get_equal(exp)
    elseif exp.type == 'function' then
        return get_function(exp)
    end
    print('未知的表达式类型', exp.type)
    return nil
end

local function base_type(type)
    while jass.types[type].extends do
        type = jass.types[type].extends
    end
    return type
end

local function new_array(type)
    local default
    local type = base_type(type)
    if type == 'boolean' then
        default = 'false'
    elseif type == 'integer' then
        default = '0'
    elseif type == 'real' then
        default = '0.0'
    else
        default = ''
    end
    return ([[new_array(%s)]]):format(default)
end

local function add_global(global)
    local value = get_exp(global[1])
    if global.array then
        value = new_array(global.type)
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

local function add_local(loc)
    local value = get_exp(loc[1])
    if loc.array then
        value = new_array(loc.type)
    end
    if not value then
        return
    end
    chunk[#chunk+1] = ([[loc.%s = %s]]):format(loc.name, value)
end

local function add_locals(locals)
    if #locals == 0 then
        return
    end
    chunk[#chunk+1] = ([[local loc = {}]])
    for _, loc in ipairs(locals) do
        add_local(loc)
    end
end

local function get_args(line)
    local args = {}
    for i, exp in ipairs(line) do
        args[i] = get_exp(exp)
    end
    return table.concat(args, ', ')
end

local function add_call(line)
    chunk[#chunk+1] = ([[%s(%s)]]):format(get_function_name(line.name), get_args(line))
end

local function add_lines(func)
    for i, line in ipairs(func) do
        if line.type == 'call' then
            add_call(line)
        else
            --print('未知的代码行类型', line.type)
        end
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
    chunk[#chunk+1] = ''
    chunk[#chunk+1] = ([[function mt.%s(%s)]]):format(func.name, table.concat(args, ', '))

    add_locals(func.locals)
    add_lines(func)
    
    chunk[#chunk+1] = 'end'
end

local function add_functions()
    for _, func in ipairs(jass.functions) do
        add_function(func)
    end
end

local function special()
    jass.functions.SetUnitState.file     = file
    jass.functions.InitGameCache.file    = file
    jass.functions.SaveGameCache.file    = file
    jass.functions.StoreInteger.file     = file
    jass.functions.GetStoredInteger.file = file
    jass.functions.FlushGameCache.file   = file
end

return function (_jass, _file)
    chunk = {}
    jass = _jass
    file = _file

    special()

    add_head()
    add_globals()
    add_functions()
    add_tail()

    return table.concat(chunk, '\r\n')
end
