local grammar = require 'parser.grammar'

local comments = {}

return function (jass, file, mode)
    local ast = grammar(jass, file, mode, parser)
    comments = {}
    return ast, comments
end
