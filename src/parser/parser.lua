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
local ast

local function parserError(str)
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

local reserved = {}
for _, key in ipairs {'globals', 'endglobals', 'constant', 'native', 'array', 'and', 'or', 'not', 'type', 'extends', 'function', 'endfunction', 'nothing', 'takes', 'returns', 'call', 'set', 'return', 'if', 'then', 'endif', 'elseif', 'else', 'loop', 'endloop', 'exitwhen', 'local', 'true', 'false'} do
    reserved[key] = true
end

local function validName(name)
    if reserved[name] then
        parserError(lang.parser.ERROR_KEY_WORD:format(name))
    end
end

local function baseType(type)
    while state.types[type].extends do
        type = state.types[type].extends
    end
    return type
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
    parserError(lang.parser.ERROR_ADD:format(t1, t2))
end

local function getSub(t1, t2)
    local vtype = getOp(t1, t2)
    if vtype then
        return vtype
    end
    parserError(lang.parser.ERROR_SUB:format(t1, t2))
end

local function getMul(t1, t2)
    local vtype = getOp(t1, t2)
    if vtype then
        return vtype
    end
    parserError(lang.parser.ERROR_MUL:format(t1, t2))
end

local function getDiv(t1, t2)
    local vtype = getOp(t1, t2)
    if vtype then
        return vtype
    end
    parserError(lang.parser.ERROR_DIV:format(t1, t2))
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
    parserError(lang.parser.ERROR_EQUAL:format(t1, t2))
end

local function getCompare(t1, t2)
    if (t1 == 'integer' or t1 == 'real') and (t2 == 'integer' or t2 == 'real') then
        return 'boolean'
    end
    parserError(lang.parser.ERROR_COMPARE:format(t1, t2))
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

local function getUnary(op, exp)
    local t = exp.vtype
    if op == 'not' then
        return t
    end
end

local function getFunction(name)
    validName(name)
    local func = state.functions[name]
    return func
end

local function getVar(name)
    validName(name)
    local var = state.locals[name] or state.args[name] or state.globals[name]
    if not var then
        parserError(lang.parser.VAR_NO_EXISTS:format(name))
        var = {}
    end
    return var
end

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
    local ast = {
        type = 'call',
        vtype = getFunction(name).vtype,
        name = name,
        ...
    }
    return ast
end

function parser.Vari(name, exp, ...)
    return {
        type = 'vari',
        vtype = getVar(name).vtype,
        name = name,
        [1] = exp,
    }
end

function parser.Var(name)
    validName(name)
    return {
        type = 'var',
        vtype = getVar(name).vtype,
        name = name,
    }
end

function parser.Neg(exp)
    local t = exp.vtype
    if t ~= 'real' and t ~= 'integer' then
        parserError(lang.parser.ERROR_NEG:format(t))
    end
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
            vtype = getBinary(op, e1, e2),
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
            vtype = getUnary(op, e1),
            [1]  = e1,
        }
    end
    return e1
end

function parser.Type(name, extends)
    local types = state.types
    if not types[extends] then
        parserError(lang.parser.ERROR_TYPE:format(extends))
    end
    if types[name] and not types[name].extends then
        parserError(lang.parser.ERROR_DEFINE_NATIVE_TYPE)
    end
    if types[name] then
        parserError(lang.parser.ERROR_REDEFINE_TYPE:format(name, types[name].file, types[name].line))
    end
    local type = {
        type    = 'type',
        file    = file,
        line    = linecount,
        name    = name,
        extends = extends,
    }
    types[name] = type
    ast.types[#ast.types+1] = type
    return type
end

function parser.GlobalsStart()
    for _, func in ipairs(ast.functions) do
        if not func.native then
            parserError(lang.parser.ERROR_GLOBAL_AFTER_FUNCTION)
        end
    end
    state.globalsStart = linecount
end

function parser.Globals(globals)
    globals.type = 'globals'
    globals.file = file
    globals.line = state.globalsStart
    return globals
end

function parser.Global(constant, type, array, name, exp)
    validName(name)
    local globals = state.globals
    local types = state.types
    if globals[name] then
        parserError(lang.parser.ERROR_REDEFINE_GLOBAL:format(name, globals[name].file, globals[name].line))
    end
    if constant == '' then
        constant = nil
    else
        constant = true
        if not exp then
            parserError(lang.parser.ERROR_CONSTANT_INIT)
        end
    end
    if not types[type] then
        parserError(lang.parser.ERROR_UNDEFINE_TYPE:format(type))
    end
    if array == '' then
        array = nil
    else
        array = true
        if exp then
            parserError(lang.parser.ERROR_ARRAY_INIT)
        end
    end
    local global = {
        file = file,
        line = linecount,
        constant = constant,
        type = type,
        vtype = type,
        array = array,
        name = name,
        [1] = exp,
    }
    globals[name] = global
    ast.globals[#ast.globals+1] = global
    return global
end

function parser.Local(type, array, name, exp)
    if not state.types[type] then
        parserError(lang.parser.ERROR_TYPE:format(type))
    end
    if array == '' then
        array = nil
    else
        array = true
        if exp then
            parserError(lang.parser.ERROR_ARRAY_INIT)
        end
    end
    if state.args[name] then
        parserError(lang.parser.ERROR_LOCAL_NAME_WITH_ARG:format(name))
    end
    local loc = {
        file = file,
        line = linecount,
        type = type,
        vtype = type,
        array = array,
        name = name,
        [1] = exp,
    }
    state.locals[name] = loc
    return loc
end

function parser.Point()
    return file, linecount
end

function parser.Action(file, line, ast)
    ast.file = file
    ast.line = line
    return ast
end

function parser.Call(name, ...)
    return {
        type = 'call',
        name = name,
        ...,
    }
end

function parser.Set(name, exp)
    return {
        type = 'set',
        name = name,
        [1]  = exp,
    }
end

function parser.Seti(name, index, exp)
    return {
        type = 'seti',
        name = name,
        [1]  = index,
        [2]  = exp,
    }
end

function parser.Return(_, exp)
    return {
        type = 'return',
        [1]  = exp,
    }
end

function parser.Exit(exp)
    if state.loop == 0 then
        parserError(lang.parser.ERROR_EXITWHEN)
    end
    return {
        type = 'exit',
        [1]  = exp,
    }
end

function parser.Logic(...)
    return {
        endline = linecount,
        type = 'if',
        ...,
    }
end

function parser.If(file, line, condition, ...)
    return {
        file = file,
        line = line,
        type = 'if',
        condition = condition,
        ...,
    }
end

function parser.Elseif(file, line, condition, ...)
    return {
        file = file,
        line = line,
        type = 'elseif',
        condition = condition,
        ...,
    }
end

function parser.Else(file, line, ...)
    return {
        file = file,
        line = line,
        type = 'else',
        ...,
    }
end

function parser.LoopStart()
    state.loop = state.loop + 1
end

function parser.LoopEnd()
    state.loop = state.loop - 1
end

function parser.Loop(_, ...)
    return {
        type = 'loop',
        endline = linecount,
        ...,
    }
end

function parser.NArgs(...)
    local takes = {...}
    local args = {}
    for i = 1, #takes, 2 do
        local arg = {
            type  = takes[i],
            vtype = takes[i],
            name  = takes[i+1],
        }
        args[#args+1] = arg
    end
    return args
end

function parser.FArgs(...)
    local takes = {...}
    local args = {}
    for i = 1, #takes, 2 do
        local arg = {
            type  = takes[i],
            vtype = takes[i],
            name  = takes[i+1],
        }
        args[#args+1] = arg
        state.args[arg.name] = arg
    end
    return args
end

function parser.Native(file, line, constant, name, args, returns)
    validName(name)
    local func = {
        file = file,
        line = line,
        type = 'function',
        native = true,
        constant = constant ~= '' or nil,
        name = name,
        args = args,
        returns = returns,
    }
    state.functions[name] = func
    ast.functions[#ast.functions+1] = func
    return func
end

function parser.Function(file, line, constant, name, args, returns, locals, ...)
    validName(name)
    local func = {
        file = file,
        line = line,
        endline = linecount,
        type = 'function',
        constant = constant ~= '' or nil,
        name = name,
        args = args,
        returns = returns,
        locals = locals,
        ...,
    }
    state.functions[name] = func
    ast.functions[#ast.functions+1] = func
    state.locals = {}
    state.args = {}
    return func
end

function parser.Jass(_, ...)
    return {...}
end

function parser.Chunk(chunk)
    return chunk
end

return function (jass_, file_, option_)
    ast = {
        types = {},
        globals = {},
        functions = {},
    }
    comments = {}
    jass = jass_
    file = file_
    linecount = 1
    option = option_ or {}
    state = option.state
    if not state then
        state = {}
        option.state = state
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
        state.locals = {}
        state.args = {}
        state.loop = 0
    end
    local gram = grammar(jass, file, option.mode, parser)
    return ast, comments, gram
end
