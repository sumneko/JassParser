local errors = ...

local expect = {
    [7]  = '函数[error_on_line_7]不存在',
    [23] = '函数[error_on_line_23]不存在',
}

for _, error in ipairs(errors) do
    local line, err = error.line, error.err
    if not expect[line] then
        return false, ('没有第[%d]行的错误'):format(line)
    end
    if expect[line] ~= err then
        return false, ('第[%d]行的错误不正确：\r\n'):format(line, err)
    end
    expect[line] = nil
end

local line, err = next(expect)
if line then
    return false, ('没有检查出第[%d]行的错误'):format(line)
end

return true
