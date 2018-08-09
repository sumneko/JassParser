local lang = require 'lang'
local m = require 'lpeglabel'

local Nl = m.P'\r\n' + m.S'\r\n'

local function calc_line(buf, line)
    local count = 0
    local res
    local Line = m.Cmt((1 - Nl)^0, function (_, _, c)
        count = count + 1
        if count == line then
            res = c
            return false
        end
        return true
    end)
    local Match = (Line * Nl)^0 * Line
    Match:match(buf)
    return res
end

return function (info)
    local line = calc_line(info.jass, info.line)
    return lang.parser.ERROR_POS:format(info.err, info.file, info.line, line)
end
