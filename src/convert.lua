local chunk
local jass
local file
local tab_count

local current_function
local get_exp
local add_lines

local function insert_line(str)
    if tab_count > 0 then
        str = ('\t'):rep(tab_count) .. str
    end
    chunk[#chunk+1] = str
end

local function struct_start()
    tab_count = tab_count + 1
end

local function struct_end()
    tab_count = tab_count - 1
end

local key_name = {'and', 'break', 'do', 'else', 'elseif', 'end', 'false', 'for', 'function', 'goto', 'if', 'in', 'local', 'nil', 'not', 'or', 'repeat', 'return', 'then', 'true', 'until', 'while'}
for _, name in ipairs(key_name) do
    key_name[name] = '_' .. name
end
local function get_available_name(name)
    return key_name[name] or name
end

local function add_head()
    insert_line [[
local jass = require 'jass.common'
local japi = require 'jass.japi'
]]

    if file == 'war3map.j' then
        insert_line [[
local bj = require 'blizzard.lua'
]]
    end

    insert_line [[
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
    insert_line [[

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

local function is_arg(name)
    if not current_function or not current_function.args then
        return false
    end
    return current_function.args[name]
end

local function get_var_name(name)
    if is_arg(name) then
        return get_available_name(name)
    end
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
    return ('%s.%s'):format(field, get_available_name(name))
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
    return ('%s.%s'):format(field, get_available_name(name))
end

local function get_call(exp)
    local args = {}
    for i, sub_exp in ipairs(exp) do
        args[i] = get_exp(sub_exp)
    end
    return ('%s(%s)'):format(get_function_name(exp.name), table.concat(args, ', '))
end

local function get_type_in_paren(exp)
    while exp.type == 'paren' do
        exp = exp[1]
    end
    return exp.type
end

local function must_string(exp)
    local type = get_type_in_paren(exp)
    if type == 'string' or type == '+' then
        return get_exp(exp)
    end
    return ('(%s or "")'):format(get_exp(exp))
end

local function get_add(exp)
    if exp.vtype == 'integer' or exp.vtype == 'real' then
        return ('%s + %s'):format(get_exp(exp[1]), get_exp(exp[2]))
    elseif exp.vtype == 'string' then
        return ('%s .. %s'):format(must_string(exp[1]), must_string(exp[2]))
    end
    error(('表达式类型错误:%s %s'):format(exp.type, exp.vtype))
end

local function get_sub(exp)
    return ('%s - %s'):format(get_exp(exp[1]), get_exp(exp[2]))
end

local function get_mul(exp)
    return ('%s * %s'):format(get_exp(exp[1]), get_exp(exp[2]))
end

local function get_div(exp)
    if exp.vtype == 'integer' then
        return ('%s // %s'):format(get_exp(exp[1]), get_exp(exp[2]))
    elseif exp.vtype == 'real' then
        return ('%s / %s'):format(get_exp(exp[1]), get_exp(exp[2]))
    end
    error(('表达式类型错误:%s %s'):format(exp.type, exp.vtype))
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

local function get_unequal(exp)
    return ('%s ~= %s'):format(get_exp(exp[1]), get_exp(exp[2]))
end

local function get_gt(exp)
    return ('%s > %s'):format(get_exp(exp[1]), get_exp(exp[2]))
end

local function get_ge(exp)
    return ('%s >= %s'):format(get_exp(exp[1]), get_exp(exp[2]))
end

local function get_lt(exp)
    return ('%s < %s'):format(get_exp(exp[1]), get_exp(exp[2]))
end

local function get_le(exp)
    return ('%s <= %s'):format(get_exp(exp[1]), get_exp(exp[2]))
end

local function get_and(exp)
    return ('%s and %s'):format(get_exp(exp[1]), get_exp(exp[2]))
end

local function get_or(exp)
    return ('%s or %s'):format(get_exp(exp[1]), get_exp(exp[2]))
end

local function get_not(exp)
    return ('not %s'):format(get_exp(exp[1]))
end

local function get_code(exp)
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
    elseif exp.type == '!=' then
        return get_unequal(exp)
    elseif exp.type == '>' then
        return get_gt(exp)
    elseif exp.type == '<' then
        return get_lt(exp)
    elseif exp.type == '>=' then
        return get_ge(exp)
    elseif exp.type == '<=' then
        return get_le(exp)
    elseif exp.type == 'and' then
        return get_and(exp)
    elseif exp.type == 'or' then
        return get_or(exp)
    elseif exp.type == 'not' then
        return get_not(exp)
    elseif exp.type == 'code' then
        return get_code(exp)
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
    insert_line(([[mt.%s = %s]]):format(global.name, value))
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
    insert_line(('%s = %s'):format(get_var_name(loc.name), value))
end

local function add_locals(locals)
    if #locals == 0 then
        return
    end
    insert_line 'local loc = {}'
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
    insert_line(('%s(%s)'):format(get_function_name(line.name), get_args(line)))
end

local function add_set(line)
    insert_line(('%s = %s'):format(get_var_name(line.name), get_exp(line[1])))
end

local function add_seti(line)
    insert_line(('%s[%s] = %s'):format(get_var_name(line.name), get_exp(line[1]), get_exp(line[2])))
end

local function add_return(line, last)
    if last then
        if line[1] then
            insert_line(('return %s'):format(get_exp(line[1])))
        else
            insert_line 'return'
        end
    else
        if line[1] then
            insert_line(('do return %s end'):format(get_exp(line[1])))
        else
            insert_line 'do return end'
        end
    end
end

local function add_exit(line)
    insert_line(('if %s then break end'):format(get_exp(line[1])))
end

local function add_if(data)
    insert_line(('if %s then'):format(get_exp(data.condition)))
    struct_start()
    add_lines(data)
    struct_end()
end

local function add_elseif(data)
    insert_line(('elseif %s then'):format(get_exp(data.condition)))
    struct_start()
    add_lines(data)
    struct_end()
end

local function add_else(data)
    insert_line 'else'
    struct_start()
    add_lines(data)
    struct_end()
end

local function add_ifs(chunk)
    for _, data in ipairs(chunk) do
        if data.type == 'if' then
            add_if(data)
        elseif data.type == 'elseif' then
            add_elseif(data)
        elseif data.type == 'else' then
            add_else(data)
        else
            print('未知的判断类型', line.type)
        end
    end
    insert_line 'end'
end

local function add_loop(chunk)
    insert_line 'for _i = 1, 1000000 do'
    struct_start()
    add_lines(chunk)
    struct_end()
    insert_line 'end'
end

function add_lines(chunk)
    for i, line in ipairs(chunk) do
        if line.type == 'call' then
            add_call(line)
        elseif line.type == 'set' then
            add_set(line)
        elseif line.type == 'seti' then
            add_seti(line)
        elseif line.type == 'return' then
            add_return(line, #chunk == i)
        elseif line.type == 'exit' then
            add_exit(line)
        elseif line.type == 'if' then
            add_ifs(line)
        elseif line.type == 'loop' then
            add_loop(line)
        else
            print('未知的代码行类型', line.type)
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
            args[i] = get_available_name(arg.name)
        end
    end
    insert_line ''
    insert_line(([[function %s(%s)]]):format(get_function_name(func.name), table.concat(args, ', ')))
    struct_start()
    add_locals(func.locals)
    add_lines(func)
    struct_end()
    insert_line 'end'
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
    tab_count = 0

    special()

    add_head()
    add_globals()
    add_functions()
    add_tail()

    return table.concat(chunk, '\r\n')
end
