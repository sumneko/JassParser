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
    for i, jass in ipairs {...} do
        local file
        if i == 1 then
            file = 'common.j'
        elseif i == 2 then
            file = 'blizzard.j'
        else
            file = 'war3map.j'
        end
        ast, comments, errors, state = parser(jass, file, option)
    end
    return ast, comments, errors, state
end

function api.check(...)
    local errors
    local option = {}
    for i, jass in ipairs {...} do
        local file
        if i == 1 then
            file = 'common.j'
        elseif i == 2 then
            file = 'blizzard.j'
        else
            file = 'war3map.j'
        end
        errors = checker(jass, file, option)
    end
    return errors
end

return api
