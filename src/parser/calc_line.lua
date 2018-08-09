local m = require 'lpeglabel'

local Nl = m.P'\r\n' + m.S'\r\n'
local Line = (1 - Nl)*

return function (buf, line)
    local Skip = (Line * Nl)^(line-1)
    local Match = Skip * C(Line)
    return Match:match(buf)
end
