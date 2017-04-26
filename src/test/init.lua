local parser = require 'parser'
local writer = require 'writer'

local IGNORE = '_IGNORE'

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
        local grm = parser(str)[1]
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

local env = setmetatable({ check = check, IGNORE = IGNORE }, _G)
local function trequire(name)
    print('语法测试:' .. name)
    assert(loadfile(package.searchpath(name, package.path), 'bt', env))()
end

require 'test.unit_test'

trequire 'test.typedef'
trequire 'test.globals'
trequire 'test.function'
trequire 'test.logic'
trequire 'test.exp'
trequire 'test.value'

print('语法测试通过')
