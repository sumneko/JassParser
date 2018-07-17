local grammar = require 'parser.grammar'

local tonumber = tonumber
local tointeger = math.tointeger
local stringByte = string.byte
local stringUnpack = string.unpack

local comments
local file
local linecount

local static = {
    NULL = {
        type = 'null',
        vtype = 'null',
    },
    TRUE = {
        type  = 'boolean',
        vtype = 'boolean',
        value = true,
    },
    FALSE = {
        type  = 'boolean',
        vtype = 'boolean',
        value = false,
    },
}

local parser = {}
function parser.nl()
    linecount = linecount + 1
end
function parser.File()
    return file
end
function parser.Line()
    return linecount
end
function parser.Comment(str)
    comments[linecount] = str
end
function parser.NULL()
    return static.NULL
end
function parser.TRUE()
    return static.TRUE
end
function parser.FALSE()
    return static.FALSE
end
function parser.String(str)
    return {
        type  = 'string',
        vtype = 'string',
        value = str,
    }
end
function parser.Real(str)
    return {
        type  = 'real',
        vtype = 'real',
        value = str,
    }
end
function parser.Integer10(neg, str)
    local int = tointeger(str)
    if neg ~= '' then
        int = - int
    end
    return {
        type  = 'integer',
        vtype = 'integer',
        value = int,
    }
end
function parser.Integer16(neg, str)
    local int = tointeger('0x'..str)
    if neg ~= '' then
        int = - int
    end
    return {
        type  = 'integer',
        vtype = 'integer',
        value = int,
    }
end
function parser.Integer256(neg, str)
    local int
    if #str == 1 then
        int = stringByte(str)
    elseif #str == 4 then
        int = stringUnpack('>I4', str)
    end
    if neg ~= '' then
        int = - int
    end
    return {
        type  = 'integer',
        vtype = 'integer',
        value = int,
    }
end
function parser.Code(name)
    return {
        type = 'code',
        vtype = 'code',
        name = name,
    }
end
function parser.Call(name, ...)
    local ast = {...}
    ast.type = 'call'
    ast.vtype = nil -- TODO 根据函数返回值计算
    ast.name = name
    return ast
end
function parser.Vari(name, exp, ...)
    return {
        type = 'vari',
        vtype = nil, -- TODO 根据变量类型计算
        name = name,
        [1] = exp,
    }
end
function parser.Var(name)
    return {
        type = 'var',
        vtype = nil, -- TODO 根据变量类型计算
        name = name,
    }
end
function parser.Neg(exp)
    return {
        type = 'neg',
        vtype = exp.vtype,
        [1] = exp,
    }
end
function parser.Binary(...)
    local e1, op = ...
    if not op then
        return e1
    end
    local args = {...}
    local e1 = args[1]
    for i = 2, #args, 2 do
        op, e2 = args[i], args[i+1]
        e1 = {
            type = op,
            [1]  = e1,
            [2]  = e2,
        }
    end
    return e1
end
function parser.Unary(...)
    local e1, op = ...
    if not op then
        return e1
    end
    local args = {...}
    local e1 = args[#args]
    for i = #args - 1, 1, -1 do
        op = args[i]
        e1 = {
            type = op,
            [1]  = e1,
        }
    end
    return e1
end

return function (jass, file_, mode)
    comments = {}
    file = file_
    linecount = 1
    local ast = grammar(jass, file, mode, parser)
    return ast, comments
end
