local m = require 'lpeglabel'

local linecount
local nlpos
local defs = {}
local nl = (m.P'\r\n' + m.S'\r\n') * m.Cp() / function (pos)
    linecount = linecount + 1
    nlpos = pos
end

local counter = (nl + m.P(1))^0

return function (buf, pos)
    linecount = 1
    nlpos = 1
    counter:match(buf:sub(1, pos))
    local line = linecount
    local col = pos - nlpos + 1
    return line, col, buf:match('[^\r\n]*', nlpos)
end
