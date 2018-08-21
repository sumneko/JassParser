local parser = require 'parser.parser'
local checker = require 'parser.checker'
local format_error = require 'parser.format_error'

local api = {
    format_error = format_error,
    parser       = parser,
    checker      = checker,
}

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
