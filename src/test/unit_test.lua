require 'filesystem'
local grammar = require 'parser.grammarlabel'

local function check_str(str, name, mode)
    local suc, res = xpcall(grammar, debug.traceback, str, 'war3map.j', mode)
    if not suc then
        error(([[
%s

[%s]测试失败:
%s
%s
%s
]]):format(
    res,
    name,
    ('='):rep(30),
    str,
    ('='):rep(30)
))
    end
end

local function check(mode)
    return function (list)
        for i, str in ipairs(list) do
            if mode ~= 'Nl' then
                str = str:gsub('[\r\n]+$', '')
            end
            check_str(str, mode .. '-' .. i, mode)
        end
    end
end

check 'Comment'
{
'//',
'//123',
'//123//123'
}

check 'Sp'
{
'',
' ',
'  ',
'\t',
'\xEF\xBB\xBF',
'//',
'//123',
' \t',
'\xEF\xBB\xBF//',
}

check 'Common'
{
'if',
' if',
'\tif',
'\xEF\xBB\xBFif'
}

check 'Nl'
{
'\n',
'\r',
'\r\n',
' \r\n',
'//123\r\n',
}

check 'Value'
{
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

check 'Name'
{
'test',
'a12_szSFS___S0',
}

check 'Exp'
{
'u',
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
'1',
'test()',
'test(1)',
'test(1, 2, 3)',
'(1!=2)',
'unit[1]',
'unit[1+2]',
'(unit[1])',
'test ()',
'test (a)',
'test(unit[1])',
'test(unit[1], unit[1+2], (1+2), unit[test(1, 2)], 2)',
'GetUnitTypeId(u) == 0',
'chance == 0 or GetUnitTypeId(u) == 0',
'function test',
'not x',
'not not x',
'not YDWEReplayWriter__IsLivingPlayer(YDWEReplayWriter__curplayer)',
}

check 'Type'
{
'type string extends agent'
}

check 'Globals'
{
[[
globals
endglobals
]],
[[
globals

endglobals
]],
[[
globals
    integer a
    integer a = 0
    constant integer a
    constant integer a = 0
    integer array a
endglobals
]],
}

check 'Local'
{
'local unit u',
'local unit u = 1',
'local unit u = xxx(aa+bb)',
'local unit array u',
}

check 'Action'
{
'call test(u)',
'set a = 1',
'set a[5] = 1',
'return',
'return 0',
'exitwhen true',
}

check 'Action'
{
[[
if a then
endif
]],
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

check 'Native'
{
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
]]
}

check 'Function'
{
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
    local unit u
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
