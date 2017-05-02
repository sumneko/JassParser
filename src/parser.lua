local token = require 'token'

local jass

local mt = {}
setmetatable(mt, mt)

mt.__index = token

function mt:__call(_jass, mode)
    jass = _jass
    local gram = token(_jass, mode)
    return gram
end

return mt