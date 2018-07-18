local grammar = require 'parser.grammar'
local lang = require 'lang'

local tonumber = tonumber
local tointeger = math.tointeger
local stringByte = string.byte
local stringUnpack = string.unpack

local jass
local comments
local state
local file
local linecount
local option

local function parser_error(str)
    if option.ignore_error then
        return
    end
    local line = linecount
    local start = 1
    while line > 1 do
        start = jass:find('[\r\n]', start)
        if not start then
            start = 1
            break
        end
        if jass:sub(start, start + 1) == '\r\n' then
            start = start + 2
        else
            start = start + 1
        end
        line = line - 1
    end
    local finish = jass:find('%f[\r\n]', start)
    if finish then
        finish = finish - 1
    else
        finish = #jass
    end
    error(lang.parser.ERROR_POS:format(str, file, linecount, jass:sub(start, finish)))
end

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

function parser.Paren(exp)
    return {
        type = 'paren',
        vtype = exp.vtype,
        [1] = exp,
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
    local t = exp.vtype
    if t ~= 'real' and t ~= 'integer' then
        parser_error(lang.parser.ERROR_NEG:format(t))
    end
    return {
        type = 'neg',
        vtype = exp.vtype,
        [1] = exp,
    }
end

local function getOp(t1, t2)
    if (t1 == 'integer' or t1 == 'real') and (t2 == 'integer' or t2 == 'real') then
        if t1 == 'real' or t2 == 'real' then
            return 'real'
        else
            return 'integer'
        end
    end
    return nil
end

local function getAdd(t1, t2)
    local vtype = getOp(t1, t2)
    if vtype then
        return vtype
    end
    if (t1 == 'string' or t1 == 'null') and (t2 == 'string' or t2 == 'null') then
        return 'string'
    end
    parser_error(lang.parser.ERROR_ADD:format(t1, t2))
end

local function getSub(t1, t2)
    local vtype = getOp(t1, t2)
    if vtype then
        return vtype
    end
    parser_error(lang.parser.ERROR_SUB:format(t1, t2))
end

local function getMul(t1, t2)
    local vtype = getOp(t1, t2)
    if vtype then
        return vtype
    end
    parser_error(lang.parser.ERROR_MUL:format(t1, t2))
end

local function getDiv(t1, t2)
    local vtype = getOp(t1, t2)
    if vtype then
        return vtype
    end
    parser_error(lang.parser.ERROR_DIV:format(t1, t2))
end

local function baseType(type)
    while state.types[type].extends do
        type = state.types[type].extends
    end
    return type
end

local function getEqual(t1, t2)
    if t1 == 'null' or t2 == 'null' then
        return 'boolean'
    end
    if (t1 == 'integer' or t1 == 'real') and (t2 == 'integer' or t2 == 'real') then
        return 'boolean'
    end
    local b1 = baseType(t1)
    local b2 = baseType(t2)
    if b1 == b2 then
        return 'boolean'
    end
    parser_error(lang.parser.ERROR_EQUAL:format(t1, t2))
end

local function getAnd(t1, t2)
    return 'boolean'
end

local function getOr(t1, t2)
    return 'boolean'
end

local function getBinary(op, e1, e2)
    local t1 = e1.vtype
    local t2 = e2.vtype
    if op == '+' then
        return getAdd(t1, t2)
    elseif op == '-' then
        return getSub(t1, t2)
    elseif op == '*' then
        return getMul(t1, t2)
    elseif op == '/' then
        return getDiv(t1, t2)
    elseif op == '==' or op == '!=' then
        return getEqual(t1, t2)
    elseif op == '>' or op == '<' or op == '>=' or op == '<=' then
        return getCompare(t1, t2)
    elseif op == 'and' then
        return getAnd(t1, t2)
    elseif op == 'or' then
        return getOr(t1, t2)
    end
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
            vtype = getBinary(op, e1, e2),
            [1]  = e1,
            [2]  = e2,
        }
    end
    return e1
end

local function getUnary(op, exp)
    local t = exp.vtype
    if op == 'not' then
        return t
    end
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
            vtype = getUnary(op, e1),
            [1]  = e1,
        }
    end
    return e1
end

function parser.Type(name, extends)
    return {
        type    = 'type',
        file    = file,
        line    = linecount,
        name    = name,
        extends = extends,
    }
end

function parser.GlobalsStart()
    state.globalsStart = linecount
end

function parser.Globals(globals)
    globals.type = 'globals'
    globals.file = file
    globals.line = state.globalsStart
    return globals
end

function parser.Global(constant, type, array, name, exp)
    return {
        file = file,
        line = linecount,
        constant = constant ~= '' or nil,
        type = type,
        array = array ~= '' or nil,
        name = name,
        [1] = exp,
    }
end

function parser.Local(type, array, name, exp)
    return {
        file = file,
        line = linecount,
        type = type,
        array = array ~= '' or nil,
        name = name,
        [1] = exp,
    }
end

return function (jass_, state_, file_, option_)
    comments = {}
    jass = jass_
    state = state_
    file = file_
    linecount = 1
    option = option_ or {}
    if not state then
        state = {}
        state.types = {
            null    = {type = 'type'},
            handle  = {type = 'type'},
            code    = {type = 'type'},
            integer = {type = 'type'},
            real    = {type = 'type'},
            boolean = {type = 'type'},
            string  = {type = 'type'},
        }
        state.globals = {}
        state.functions = {}
    end
    local ast = grammar(jass, file, option.mode, parser)
    return ast, state, comments
end
