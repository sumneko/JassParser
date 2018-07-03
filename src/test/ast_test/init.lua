local grammar = require 'parser.grammarlabel'

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

local function trequire(name)
    print('语法测试:' .. name)

    local function check(str)
        return function(tbl)
            if name ~= 'Jass' then
                str = str:gsub('[\r\n]+$', '')
            end
            local res = grammar(str, 'war3map.j', name)
            if not checkeq(res, tbl) then
                print('=========jass========')
                print(str)
                print('========语法树=======')
                print(writer(res))
                print('=========期望========')
                print(writer(tbl))
                error('语法测试未通过')
            end
        end
    end

    local filename = 'test.ast_test.' .. name
    local env = setmetatable({ check = check }, _G)
    assert(loadfile(package.searchpath(filename, package.path), 'bt', env))()
end

trequire 'Value'
