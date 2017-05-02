require 'filesystem'
local token = require 'token'
local uni = require 'unicode'

local function check_str(str, name, mode)
    local suc, res = pcall(token, str, mode)
    if not suc then
        error(uni.a2u(res) .. '\n\n' .. name .. '测试失败:\n' .. ('='):rep(30) .. '\n' .. str .. '\n' .. ('='):rep(30))
    end
end

local function check(list, mode)
    for _, str in ipairs(list) do
        check_str(str, mode, mode)
    end
end

local word_list = {
'1',
'-1',
'- 1',
'0',
'55',
'$012345ad',
'$012345AD',
'0X012345AD',
'0xafBD12cE',
'12.34',
'-12.34',
'.34',
'-.34',
'12.',
'-12.',
'- 2',
'- 1.2',
'true',
'false',
'""',
'"测试"',
[["测试\""]],
[["测试\\"]],
[["测试
测试"]],
}

check(word_list, 'Value')

local id_list = {
'test',
'a12_szSFS___S0',
}

check(id_list, 'id')

local exp_list = {
'(test)',
'((test))',
'1+2',
'1*2',
'1+2+3',
'2*(3+4)',
'1 == 2',
'1 +2> 4',
'2!=4',
'1+2*3==2*3+4',
'1==2 and 3!=4',
'1//注释',
'test()',
'test(1)',
'test(1, 2, 3)',
'(1!=2)',
'unit[1]',
'unit[1+2]',
'(unit[1])',
'test(unit[1])',
'test(unit[1], unit[1+2], (1+2), unit[test(1, 2)], 2)',
'GetUnitTypeId(u) == 0',
'chance == 0 or GetUnitTypeId(u) == 0',
'function test',
'not x',
'not not x',
'not YDWEReplayWriter__IsLivingPlayer(YDWEReplayWriter__curplayer)',
}

check(exp_list, 'exp')

local line_list = {
'call test(u)',
'set a = 1',
'set a[5] = 1',
'return',
'return 0',
}

check(line_list, 'line')

local logic_list = {
[[
if a then
endif
]],
[[
if a then
    set a = 1
endif
]],
[[
loop
endloop
]],
[[
loop
    set a = 1
endloop
]],
[[
loop
    set a = 1
    exitwhen a == 1
endloop
]],
[[
if a then
    //exitwhen true
endif
]],
[[
loop
    if a then
    endif
endloop
]],
[[
if a then
    loop
    endloop
endif
]],
[[
if a then
    set a = 1 + 1
elseif b then
    call u(v)
else
    if c then
    endif
endif
]],
[[
loop
    exitwhen i > 10
    if a then
        loop
            if b then
            endif
        endloop
    endif
endloop
]],
[[
loop
    if a then
        exitwhen true
    endif
endloop
]]
}

check(logic_list, 'logic')

local loc_list = {
'local unit u',
'local unit u = 1',
'local unit u = xxx(aa+bb)',
'local unit array u',
}

check(loc_list, 'loc')

local func_list = {
[[
native test takes nothing returns nothing
]],
[[
native test takes nothing returns unit
]],
[[
native test takes unit u returns unit
]],
[[
native test takes unit u, integer i returns unit
]],
[[
function test takes nothing returns nothing
endfunction
]],
[[
function test takes unit u, integer i returns unit
endfunction
]],
[[
function test takes unit u, integer i returns unit
    local unit
endfunction
]],
[[
function test takes unit u, integer i returns unit
    local unit u
    local unit u = 1
    local unit u = xxx(aa+bb)
    local unit array u
endfunction
]],
[[
function test takes unit u, integer i returns unit
    call xxx(bb)
endfunction
]],
[[
function test takes unit u, integer i returns unit
    local unit u
    local unit u = 1
    local unit u = xxx(aa+bb)
    local unit array u
    call xxx(bb)
endfunction
]],
[[
function test takes unit u, integer i returns unit
    local unit u
    local unit u = 1
    local unit u = xxx(aa+bb)
    local unit array u
    call xxx(bb)
    set xxx = xxx
endfunction
]],
[[
function test takes unit u, integer i returns unit
    local unit u = xxx(aa+bb)
    call xxx(bb)
    set xxx = xxx
    return
endfunction
]],
[[
function test takes unit u, integer i returns unit
    local unit u = xxx(aa+bb)
    call xxx(bb)
    set xxx = xxx
    return 1 + 1
endfunction
]],
[[
function test takes unit u, integer i returns unit
    local unit u = xxx(aa+bb)
    call xxx(bb)
    set xxx = xxx
    return 1 + 1
    if a then
        loop
            if b then
                exitwhen true
            endif
        endloop
    endif
endfunction
]],
}

-- 外部单元测试
local check_path = fs.current_path() / 'src' / 'should-check'
local ignore = {
    ['absolute-garbage.j']  = true,  -- 语法不正确
}
for path in check_path:list_directory() do
    local file_name = path:filename():string()
    if not ignore[file_name] then
        local str = io.load(path)
        check_str(str, file_name)
    end
end


-- 压力测试
--print '开始压力锅测试'
--
--local function check(str, name)
--    parser:line_count(1)
--    local clock = os.clock()
--    local suc, err = pcall(lpeg.match, parser.pjass, str)
--    print(name, '测试结果', suc, '用时', os.clock() - clock)
--    if not suc then
--        print(uni.a2u(err))
--    end
--end
--
--local str = ('%s\n%s\n%s'):format(
--    'function test takes nothing returns nothing',
--    'call ' .. ('test('):rep(100) .. (')'):rep(100),
--    'endfunction'
--)
--lpeg.setmaxstack(3000)
--check(str, '压力测试1')
--
--local str = ('%s\n%s\n%s\n%s'):format(
--    'function test takes nothing returns nothing',
--    ('if true then\n'):rep(100),
--    ('endif\n'):rep(100),
--    'endfunction'
--)
--
--lpeg.setmaxstack(1626)
--check(str, '压力测试2')
--
--local str = ('%s\n%s\n%s'):format(
--    'function test takes nothing returns nothing',
--    ('call test()\n'):rep(100000),
--    'endfunction'
--)
--check(str, '压力测试3')

print('单元测试完成,用时', os.clock(), '秒')
