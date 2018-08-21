-- 检查单个脚本文件，会使用工具内置的common.j和blizzard.j(1.24e)

root = arg[0] .. '\\..'
package.path = package.path .. ';' .. root .. '\\src\\?.lua'
                            .. ';' .. root .. '\\src\\?\\init.lua'

require 'filesystem'
require 'utility'
local root = fs.path(root)
local parser = require 'parser'
local showerror = require 'gui.showerror'

local function show_error(filename, info)
    showerror(root / 'src' / 'gui', info.err, filename, info.line)
end

local function format_error(info)
    return ([[%s:%d:  %s]]):format(info.file, info.line, info.err)
end

local function command()
    local res = {}
    for i = 1, #arg do
        local cmd = arg[i]
        if cmd:sub(1, 1) == '-' then
            local k, v
            local pos = cmd:find('=', 1, true)
            if pos then
                k = cmd:sub(2, pos - 1)
                v = cmd:sub(pos + 1)
            else
                k = cmd:sub(2)
                v = true
            end
            res[k] = v
        else
            res[#res+1] = cmd
        end
    end
    return res
end

local function parse(filename, option, gui)
    local file = io.load(filename)
    if not file then
        print('不能打开文件:', filename:string())
        option.Error = option.Error + 1
        return false
    end
    local errors = parser.checker(file, filename:filename():string(), option)
    if #errors > 0 then
        for _, error in ipairs(errors) do
            if error.level == 'warning' then
                print(format_error(error))
                option.Warning = option.Warning + 1
            end
        end
        local hasError = false
        for _, error in ipairs(errors) do
            if error.level == 'error' then
                print(format_error(error))
                option.Error = option.Error + 1
                if gui then
                    show_error(filename, error)
                end
                hasError = true
            end
        end
        return not hasError
    end
    print('检查完成:', filename:string())
    return true
end

local function main()
    local cmd = command()
    if not cmd[1] then
        print('请输入脚本路径')
        return
    end

    local option = {
        Error = 0,
        Warning = 0,
    }
    local suc, errors = xpcall(function()
        local gui = not not cmd.gui
        if cmd.ver then
            option.Version = tonumber(cmd.ver)
            if not parse(root / 'standard' / cmd.ver / 'common.j', option, gui) then
                return
            end
            if not parse(root / 'standard' / cmd.ver / 'blizzard.j', option, gui) then
                return
            end
        end
        for _, c in ipairs(cmd) do
            if not parse(fs.path(c), option, gui) then
                return
            end
        end
    end, debug.traceback)
    if not suc then
        print(errors)
        return
    end
    if option.Error > 0 then
        print('检查失败:', ('%d 个错误, %d 个警告'):format(option.Error, option.Warning))
    else
        print('检查成功:', ('%d 个错误, %d 个警告'):format(option.Error, option.Warning))
    end
end

main()
