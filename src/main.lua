local exepath
(function()
	exepath = package.cpath:sub(1, package.cpath:find(';')-6)
	package.path = package.path .. ';' .. exepath .. '..\\?.lua'
	package.path = package.path .. ';' .. exepath .. '..\\?\\init.lua'
end)()

require 'filesystem'
require 'utility'
local uni  = require 'unicode'
local convert_lua = require 'convert_lua'
local parser = require 'parser'
local writer = require 'writer'

local function load_in_env(name, env)
    local path = package.searchpath(name, package.path)
    return assert(load(io.load(fs.path(path)), path, 't', setmetatable(env, { __index = _G })))()
end

local function main()
    local root = fs.path(uni.a2u(exepath)):parent_path():parent_path():parent_path()
    print(root)
    convert_lua:init(root)
    if not arg[1] then
        require 'test'
        return
    end
    local jass = io.load(fs.path(uni.a2u(arg[1])))
    local war3map, blizzard, gram = convert_lua(jass)
    --print('转换完成,生成测试文本...')
    --local buf = writer(t)
    --io.save(root / '语法树.lua', buf)
    io.save(root / 'blizzard.lua', blizzard)
    io.save(root / 'war3map.lua', war3map)
    print('完成')
end

main()
