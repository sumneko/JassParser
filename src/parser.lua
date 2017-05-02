local token = require 'token'

local jass

local mt = {}
setmetatable(mt, mt)
mt.__index = token

function mt:error(str, line_count)
    error(('line[%d]: %s'):format(line_count, str))
end

function mt:parse_globals(chunk)
    if #self.functions > 0 then
        self:error('全局变量必须在函数前定义', chunk.line)
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
    return result
end

return mt