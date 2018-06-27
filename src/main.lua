(function()
	local exepath = package.cpath:sub(1, package.cpath:find(';')-6)
	package.path = package.path .. ';' .. exepath .. '..\\src\\?.lua'
	package.path = package.path .. ';' .. exepath .. '..\\src\\?\\init.lua'
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
    if arg[1] then
        local exepath  = package.cpath:sub(1, package.cpath:find(';')-6)
        local root     = fs.path(uni.a2u(exepath)):parent_path():parent_path()
        local common   = io.load(root / 'src' / 'jass' / 'common.j')
        local blizzard = io.load(root / 'src' / 'jass' / 'blizzard.j')

        local path = fs.path(arg[1])
        local jass = io.load(path)

        local clock = os.clock()
        local ast, grms
        local suc, e = xpcall(function()
            ast, grms = parser(common,   'common.j',   ast)
            ast, grms = parser(blizzard, 'blizzard.j', ast)
            ast, grms = parser(jass,     'war3map.j',  ast)
        end, error_handle)
        if not suc then
            print(e)
        end
        print(('脚本校验完成，长度为[%d]，用时[%s]'):format(#jass, os.clock() - clock))
    else
        require 'test'
    end
    print('完成')
end

main()
