local re = require 'parser.relabel'

local rev = re.compile[[
    R <- (!.) -> '' / ({.} R) -> '%2%1'
]]

print(rev:match '01234566789')
