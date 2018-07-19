local parser = require 'parser.parser'

local api = {}

function api.parser(jass, file)
    return parser(jass, file, {
        mode = 'Jass'
    })
end

function api.war3map(...)
    local ast, comments
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
        ast, comments = parser(jass, file, option)
    end
    return ast, comments
end

return api
