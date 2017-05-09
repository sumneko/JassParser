local parser = require 'parser'
local writer = require 'writer'
local uni    = require 'unicode'

local IGNORE = '_IGNORE'

local exepath = package.cpath:sub(1, package.cpath:find(';')-6)
local root = fs.path(uni.a2u(exepath)):parent_path():parent_path():parent_path()
local common   = io.load(root / 'src' / 'jass' / 'common.j')
local blizzard = io.load(root / 'src' / 'jass' / 'blizzard.j')

local function checkeq (x, y, p)
    if x == IGNORE or y == IGNORE then
        return x and y
    end
    if p then
        print(x, y)
    end
    if type(x) == "table" and type(y) == 'table' then
        for k, v in pairs(x) do 
            if not checkeq(v, y[k], p) then
                return false
            end
        end
        for k, v in pairs(y) do
            if not checkeq(v, x[k], p) then
                return false
            end
        end
        return true
    else
        return x == y
    end
end


local function check(str)
    return function(tbl)
        local ast, grms
        local suc, e = xpcall(function()
            ast, grms = parser(common,   'common.j',   ast)
            ast, grms = parser(blizzard, 'blizzard.j', ast)
            ast, grms = parser(str,      'war3map.j',  ast)
        end, error_handle)
        if not suc then
            print(str)
            print(e)
            return
        end
        local grm = grms[1]
        if not checkeq(grm, tbl) then
            print('=========jass========')
            print(str)
            print('========语法树=======')
            print(writer(grm))
            print('=========期望========')
            print(writer(tbl))
            error('语法测试未通过')
        end
    end
end

local env = setmetatable({ check = check }, _G)
local function trequire(name)
    print('语法测试:' .. name)
    assert(loadfile(package.searchpath(name, package.path), 'bt', env))()
end

require 'test.unit_test'
require 'test.fail_test'

trequire 'test.Type'
trequire 'test.Globals'
trequire 'test.Function'
trequire 'test.Logic'
trequire 'test.Exp'
trequire 'test.Value'

print('语法测试通过')
