local parser = require 'parser.parser'
local checker = require 'parser.checker'
local format_error = require 'parser.format_error'

local api = {
    format_error = format_error,
}

function api.parser(jass, file, option)
    if not option then
        option = {}
    end
    if not option.mode then
        option.mode = 'Jass'
    end
    return parser(jass, file, option)
end

function api.checker(jass, file, option)
    if not option then
        option = {}
    end
    if not option.mode then
        option.mode = 'Jass'
    end
    return checker(jass, file, option)
end

function api.parse(...)
    local ast, comments, errors
    local option = { mode = 'Jass' }
    for i, jass in ipairs {...} do
        local file
        if i == 1 then
            file = 'common.j'
        elseif i == 2 then
            file = 'blizzard.j'
        else
            file = 'war3map.j'
        end
        ast, comments, errors = parser(jass, file, option)
    end
    return ast, comments, errors
end

function api.check(...)
    local errors
    local option = { mode = 'Jass' }
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
