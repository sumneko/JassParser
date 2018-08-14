local parser = require 'parser'
local writer = require 'writer'

local function validKey(k)
    if type(k) ~= 'string' then
        return true
    end
    if k:sub(1, 1) == '_' then
        return false
    end
    return true
end

local function checkeq (x, y, p)
    if p then
        print(x, y)
    end
    if type(x) == "table" and type(y) == 'table' then
        for k, v in pairs(x) do 
            if validKey(k) and not checkeq(v, y[k], p) then
                return false
            end
        end
        for k, v in pairs(y) do
            if validKey(k) and not checkeq(v, x[k], p) then
                return false
            end
        end
        return true
    else
        return x == y
    end
end

local function test(name)
    local function check(str)
        return function(tbl)
            if name ~= 'Jass' then
                str = str:gsub('[\r\n]+$', '')
            end
            local ast, comments, errors, state, gram = parser.parser(str, 'war3map.j', {
                mode = name,
            })
            if type(gram) ~= 'table' then
                local lines = {}
                lines[#lines+1] = '没能匹配成语法树'
                lines[#lines+1] = '=========jass========'
                lines[#lines+1] = str
                lines[#lines+1] = '=========结果========'
                lines[#lines+1] = tostring(gram)
                error(table.concat(lines, '\n'))
            end
            if not checkeq(gram, tbl) then
                local lines = {}
                lines[#lines+1] = '语法测试未通过'
                lines[#lines+1] = '=========jass========'
                lines[#lines+1] = str
                lines[#lines+1] = '========语法树======='
                lines[#lines+1] = writer(gram)
                lines[#lines+1] = '=========期望========'
                lines[#lines+1] = writer(tbl)
                error(table.concat(lines, '\n'))
            end
            return function (tbl)
                if not checkeq(comments, tbl) then
                    local lines = {}
                    lines[#lines+1] = '注释测试未通过'
                    lines[#lines+1] = '=========jass========'
                    lines[#lines+1] = str
                    lines[#lines+1] = '=========注释======='
                    lines[#lines+1] = writer(comments)
                    lines[#lines+1] = '=========期望========'
                    lines[#lines+1] = writer(tbl)
                    error(table.concat(lines, '\n'))
                end
            end
        end
    end

    local filename = 'ast.' .. name
    local env = setmetatable({ check = check }, _G)
    assert(loadfile(package.searchpath(filename, package.path), 'bt', env))()
end

test 'Value'
test 'Exp'
test 'Type'
test 'Globals'
test 'Local'
test 'Action'
test 'Native'
test 'Function'
test 'Jass'
