local token = require 'token'

local jass

local mt = {}
setmetatable(mt, mt)
mt.__index = token

function mt:error(str, line_count)
    error(('第[%d]行: %s'):format(line_count, str))
end

function mt:parse_global(data)
    if self.globals[data.name] then
        self:error(('全局变量重名 --> [%s]已经定义在第[%d]行'):format(data.name, self.globals[data.name].line), data.line)
    end
    if data.constant then
        if not data[1] then
            self:error('常量必须初始化', data.line)
        end
    end
    table.insert(self.globals, data)
    self.globals[data.name] = data
end

function mt:parse_globals(chunk)
    if #self.functions > 0 then
        self:error('全局变量必须在函数前定义', chunk.line)
    end
    for _, data in ipairs(chunk) do
        self:parse_global(data)
    end
end

function mt:parse_function(chunk)
    table.insert(self.functions, chunk)
end

function mt:parser(gram)
    for i, chunk in ipairs(gram) do
        if chunk.type == 'globals' then
            self:parse_globals(chunk)
        elseif chunk.type == 'function' then
            self:parse_function(chunk)
        elseif chunk.type == 'type' then
        else
            error('未知的区块类型:'..chunk.type)
        end
    end
end

function mt:__call(_jass)
    jass = _jass
    local result = setmetatable({}, { __index = mt})

    result.types = {}
    result.globals = {}
    result.functions = {}

    local gram = token(_jass)
    result:parser(gram)
    return result, gram
end

return mt