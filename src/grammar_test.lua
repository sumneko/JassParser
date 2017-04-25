local parser = require 'parser'

local function checkeq (x, y, p)
    if p then
        print(x, y)
    end
    if type(x) ~= "table" then
        assert(x == y)
    else
        for k,v in pairs(x) do checkeq(v, y[k], p) end
        for k,v in pairs(y) do checkeq(v, x[k], p) end
    end
end
