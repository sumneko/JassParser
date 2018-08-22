local errors = ...

local expect = {
    ['缺少endif --> if定义在第[4]行。'] = 10,
    ['缺少endloop --> loop定义在第[6]行。'] = 10,
}

for _, error in ipairs(errors) do
    local line, err = error.line, error.err
    if expect[err] ~= line then
        return false, ('第[%d]行出现错误：%s'):format(line, err)
    end
    expect[err] = nil
end

local err, line = next(expect)
if line then
    return false, ('没有检查出[%s]'):format(err)
end

return true
