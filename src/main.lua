(function()
	local exepath = package.cpath:sub(1, package.cpath:find(';')-6)
	package.path = package.path .. ';' .. exepath .. '..\\?.lua'
	package.path = package.path .. ';' .. exepath .. '..\\?\\init.lua'
end)()

require 'filesystem'
require 'utility'
local uni  = require 'unicode'
local parser = require 'parser'
local writer = require 'writer'

local function load_in_env(name, env)
    local path = package.searchpath(name, package.path)
    return assert(load(io.load(fs.path(path)), path, 't', setmetatable(env, { __index = _G })))()
end

local function main()
    require 'test'
    print('完成')
end

main()
