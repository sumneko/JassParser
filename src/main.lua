(function()
	local exepath = package.cpath:sub(1, package.cpath:find(';')-6)
	package.path = package.path .. ';' .. exepath .. '..\\?.lua'
end)()

require 'filesystem'
require 'utility'
local uni  = require 'unicode'
local parser = require 'parser'

local function load_in_env(name, env)
    local path = package.searchpath(name, package.path)
    return assert(load(io.load(fs.path(path)), path, 't', setmetatable(env, { __index = _G })))()
end

local function main()
    if not arg[1] then
        local test = require 'test'
        return
    end
    local t = {}
    for i = 1, 4 do
        if arg[i] then
            local jass = io.load(fs.path(uni.a2u(arg[i])))
            t[i] = parser(jass)
        end
    end
    local jass, cj, bj, as = t[1], t[2], t[3], t[4]
    print(jass)
end

main()
