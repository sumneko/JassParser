local parser = require 'parser'
local convert = require 'convert'

local jass
local root
local file

local mt = {}
setmetatable(mt, mt)
mt.__index = parser

function mt:error(str, line_count)
    error(('第[%d]行: %s'):format(line_count, str))
end

function mt:parse_type(data)
    if not self.types[data.extends] then
        self:error(('类型[%s]未定义'):format(data.extends), data.line)
    end
    if self.types[data.name] and not self.types[data.name].extends then
        self:error('不能重新定义本地类型', data.line)
    end
    if self.types[data.name] then
        self:error(('类型[%s]重复定义 --> 已经定义在[%s]第[%d]行'):format(data.name, self.types[data.name].file, self.types[data.name].line), data.line)
    end
    data.file = file
    self.types[data.name] = data
end

function mt:parse_global(data)
    if self.globals[data.name] then
        self:error(('全局变量[%s]重复定义 --> 已经定义在[%s]第[%d]行'):format(data.name, self.globals[data.name].file, self.globals[data.name].line), data.line)
    end
    if data.constant and not data[1] then
        self:error('常量必须初始化', data.line)
    end
    if not self.types[data.type] then
        self:error(('类型[%s]未定义'):format(data.type), data.line)
    end
    if data.array and data[1] then
        self:error('数组不能直接初始化', data.line)
    end
    data.file = file
    table.insert(self.globals, data)
    self.globals[data.name] = data
end

function mt:parse_globals(chunk)
    for _, func in ipairs(self.functions) do
        if not func.native then
            self:error('全局变量必须在函数前定义', chunk.line)
        end
    end
    for _, data in ipairs(chunk) do
        self:parse_global(data)
    end
end

function mt:parse_function(chunk)
    table.insert(self.functions, chunk)
    self.functions[chunk.name] = chunk
end

function mt:parser(gram)
    for i, chunk in ipairs(gram) do
        if chunk.type == 'globals' then
            self:parse_globals(chunk)
        elseif chunk.type == 'function' then
            self:parse_function(chunk)
        elseif chunk.type == 'type' then
            self:parse_type(chunk)
        else
            error('未知的区块类型:'..chunk.type)
        end
    end
end

function mt:parse_jass(jass, _file)
    file = _file
    for i = 1, #self.functions do
        self.functions[i] = nil
    end
    for i = 1, #self.globals do
        self.globals[i] = nil
    end

    --local clock = os.clock()
    --collectgarbage()
    --collectgarbage()
    --local m = collectgarbage 'count'
    --print('任务:', name)
    local gram = parser(jass)
    --print('用时:', os.clock() - clock)
    --collectgarbage()
    --collectgarbage()
    --print('内存:', collectgarbage 'count' - m, 'k')

    self:parser(gram, file)
    return gram
end

function mt:init(_root)
    root = _root
end

function mt:__call(_jass)
    jass = _jass
    local result = setmetatable({}, { __index = mt})

    result.types = {
        handle  = {type = 'type'},
        code    = {type = 'type'},
        integer = {type = 'type'},
        real    = {type = 'type'},
        boolean = {type = 'type'},
        string  = {type = 'type'},
    }
    result.globals = {}
    result.functions = {}

    local cj = io.load(root / 'src' / 'jass' / 'common.j')
    local bj = io.load(root / 'src' / 'jass' / 'blizzard.j')

    result:parse_jass(cj, 'common.j')
    result:parse_jass(bj, 'blizzard.j')

    local gram = result:parse_jass(_jass, 'war3map.j')
    
    local lua = convert(result)
    return lua, gram
end

return mt