local parser = require 'parser'
local convert = require 'convert'

local jass
local check

local mt = {}
setmetatable(mt, mt)
mt.__index = parser

function mt:error(str, line_count)
    error(('第[%d]行: %s'):format(line_count, str))
end

function mt:parse_type(data)
    if check then
        if not self.types[data.extends] then
            self:error(('类型[%s]未定义'):format(data.extends), data.line)
        end
        if self.types[data.name] == true then
            self:error('不能重新定义本地类型', data.line)
        end
        if self.types[data.name] then
            self:error(('类型[%s]重复定义 --> 已经定义在第[%d]行'):format(data.name, self.types[data.name].line), data.line)
        end
    end
    self.types[data.name] = data
end

function mt:parse_global(data)
    if check then
        if self.globals[data.name] then
            self:error(('全局变量[%s]重复定义 --> 已经定义在第[%d]行'):format(data.name, self.globals[data.name].line), data.line)
        end
        if data.constant and not data[1] then
            self:error('常量必须初始化', data.line)
        end
        if not self.types[data.type] then
            self:error(('类型[%s]未定义'):format(data.type), data.line)
        end
        if data.array and data[1] then
            self:error('数组不能直接初始化', data.line)
        end
    end
    table.insert(self.globals, data)
    self.globals[data.name] = data
end

function mt:parse_globals(chunk)
    if check then
        if #self.functions > 0 then
            self:error('全局变量必须在函数前定义', chunk.line)
        end
    end
    for _, data in ipairs(chunk) do
        self:parse_global(data)
    end
end

function mt:parse_function(chunk)
    if chunk.native then
        self.natives[chunk.name] = true
    else
        table.insert(self.functions, chunk)
    end
end

function mt:parser(gram)
    for i, chunk in ipairs(gram) do
        if chunk.type == 'globals' then
            self:parse_globals(chunk)
        elseif chunk.type == 'function' then
            self:parse_function(chunk)
        elseif chunk.type == 'type' then
            self:parse_type(chunk)
        else
            error('未知的区块类型:'..chunk.type)
        end
    end
end

function mt:__call(_jass, _check)
    jass = _jass
    check = _check
    local result = setmetatable({}, { __index = mt})

    result.types = {
        handle  = true,
        agent   = true,
        code    = true,
        integer = true,
        real    = true,
        boolean = true,
        string  = true,
    }
    result.globals = {}
    result.functions = {}
    result.natives = {}
    
    local clock = os.clock()
    collectgarbage()
    collectgarbage()
    local m = collectgarbage 'count'
    local gram = parser(_jass)
    print('用时:', os.clock() - clock)
    collectgarbage()
    collectgarbage()
    print('内存:', collectgarbage 'count' - m, 'k')
    
    result:parser(gram)
    local lua = convert(result)
    return lua, gram
end

return mt