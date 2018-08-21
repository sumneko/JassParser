local parser = require 'parser.parser'
local checker = require 'parser.checker'
local calcline = require 'parser.calcline'
local lang = require 'lang'

local api = {
    parser       = parser,
    checker      = checker,
}

function api.format_error(info)
    local line = calcline(info.jass, info.line)
    return lang.parser.ERROR_POS:format(info.err, info.file, info.line, line)
end

function api.parse(...)
    local ast, comments, errors, state
    local option = {}
    for i, pack in ipairs {...} do
        ast, comments, errors, state = parser(pack[1], pack[2], option)
    end
    return ast, comments, errors, state
end

function api.check(...)
    local errors
    local option = {}
    for i, pack in ipairs {...} do
        errors = checker(pack[1], pack[2], option)
    end
    return errors
end

return api
