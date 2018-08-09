local lang = require 'lang'
local m = require 'lpeglabel'

local Nl = m.P'\r\n' + m.S'\r\n'
local Line = (1 - Nl)^0

local function calc_line(buf, line)
    local Skip = (Line * Nl)^(-line+1)
    local Match = Skip * m.C(Line)
    return Match:match(buf)
end

return function (info)
    local line = calc_line(info.jass, info.line)
    return lang.PARSER.ERROR_POS:format(info.err, info.file, info.line, line)
end
