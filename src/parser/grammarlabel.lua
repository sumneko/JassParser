local re = require 'parser.relabel'
local m = require 'lpeglabel'
local lang = require 'lang'

local scriptBuf = ''
local compiled = {}
local defs = {}
local file
local linecount
local comments

defs.nl = (m.P'\r\n' + m.S'\r\n') / function ()
    linecount = linecount + 1
end
defs.s  = m.S' \t' + m.P'\xEF\xBB\xBF'
defs.S  = - defs.s
function defs.File()
    return file
end
function defs.Line()
    return linecount
end
function defs.True()
    return true
end
function defs.False()
    return false
end
function defs.Integer10(neg, str)
    local int = math.tointeger(str)
    if neg == '' then
        return int
    else
        return - int
    end
end
function defs.Integer16(neg, str)
    local int = math.tointeger('0x'..str)
    if neg == '' then
        return int
    else
        return - int
    end
end
function defs.Integer256(neg, str)
    local int
    if #str == 1 then
        int = str:byte()
    elseif #str == 4 then
        int = ('>I4'):unpack(str)
    end
    if neg == '' then
        return int
    else
        return - int
    end
end
function defs.Binary(...)
    local e1, op = ...
    if not op then
        return e1
    end
    local args = {...}
    local e1 = args[1]
    for i = 2, #args, 2 do
        op, e2 = args[i], args[i+1]
        e1 = {
            type = op,
            [1]  = e1,
            [2]  = e2,
        }
    end
    return e1
end
function defs.Unary(...)
    local e1, op = ...
    if not op then
        return e1
    end
    local args = {...}
    local e1 = args[#args]
    for i = #args - 1, 1, -1 do
        op = args[i]
        e1 = {
            type = op,
            [1]  = e1,
        }
    end
    return e1
end

local eof = re.compile '!. / %{SYNTAX_ERROR}'

local function grammar(tag)
    return function (script)
        scriptBuf = script .. '\r\n' .. scriptBuf
        compiled[tag] = re.compile(scriptBuf, defs) * eof
    end
end

grammar 'Comment' [[
Comment     <-  '//' [^%nl]*
]]

grammar 'Sp' [[
Sp          <-  (%s / Comment)*
]]

grammar 'Nl' [[
Nl          <-  (Sp %nl)+
]]

grammar 'Common' [[
RESERVED    <-  GLOBALS / ENDGLOBALS / CONSTANT / NATIVE / ARRAY / AND / OR / NOT / TYPE / EXTENDS / FUNCTION / ENDFUNCTION / NOTHING / TAKES / RETURNS / CALL / SET / RETURN / IF / ENDIF / ELSEIF / ELSE / LOOP / ENDLOOP / EXITWHEN
Cut         <-  ![a-zA-Z0-9_]
COMMA       <-  Sp ','
ASSIGN      <-  Sp '=' !'='
GLOBALS     <-  Sp 'globals' Cut
ENDGLOBALS  <-  Sp 'endglobals' Cut
CONSTANT    <-  Sp 'constant' Cut
NATIVE      <-  Sp 'native' Cut
ARRAY       <-  Sp 'array' Cut
AND         <-  Sp 'and' Cut
OR          <-  Sp 'or' Cut
NOT         <-  Sp 'not' Cut
TYPE        <-  Sp 'type' Cut
EXTENDS     <-  Sp 'extends' Cut
FUNCTION    <-  Sp 'function' Cut
ENDFUNCTION <-  Sp 'endfunction' Cut
NOTHING     <-  Sp 'nothing' Cut
TAKES       <-  Sp 'takes' Cut
RETURNS     <-  Sp 'returns' Cut
CALL        <-  Sp 'call' Cut
SET         <-  Sp 'set' Cut
RETURN      <-  Sp 'return' Cut
IF          <-  Sp 'if' Cut
THEN        <-  Sp 'then' Cut
ENDIF       <-  Sp 'endif' Cut
ELSEIF      <-  Sp 'elseif' Cut
ELSE        <-  Sp 'else' Cut
LOOP        <-  Sp 'loop' Cut
ENDLOOP     <-  Sp 'endloop' Cut
EXITWHEN    <-  Sp 'exitwhen' Cut
LOCAL       <-  Sp 'local' Cut
TRUE        <-  Sp 'true' Cut
FALSE       <-  Sp 'false' Cut
]]

grammar 'Value' [[
Value       <-  {| NULL / Boolean / String / Real / Integer |}
NULL        <-  Sp 'null' Cut
                {:type: '' -> 'null' :}

Boolean     <-  {:value: TRUE -> True / FALSE -> False :}
                {:type: '' -> 'boolean' :}

StringC     <-  Sp '"' {(SEsc / [^"])*} '"'
SEsc        <-  '\' .
String      <-  {:value: StringC :}
                {:type: '' -> 'string' :}

RealC       <-  Sp {'-'? Sp (('.' [0-9]+) / ([0-9]+ '.' [0-9]*))}
Real        <-  {:value: RealC :}
                {:type: '' -> 'real' :}

Integer10   <-  Sp ({'-'?} Sp {'0' / ([1-9] [0-9]*)})
            ->  Integer10
Integer16   <-  Sp ({'-'?} Sp ('$' / '0x' / '0X') {[a-fA-F0-9]+})
            ->  Integer16
Integer256  <-  Sp ({'-'?} Sp "'" {('\\' / "\'" / (!"'" .))*} "'")
            ->  Integer256
Integer     <-  {:value: Integer16 / Integer10 / Integer256 :}
                {:type: '' -> 'integer' :}
]]

grammar 'Name' [[
Name        <-  !RESERVED Sp {[a-zA-Z] [a-zA-Z0-9_]*}
-- TODO 先匹配名字再通过表的key来排除预设值可以提升性能？
]]

grammar 'Compare' [[
GT          <-  Sp '>'
GE          <-  Sp '>='
LT          <-  Sp '<'
LE          <-  Sp '<='
EQ          <-  Sp '=='
UE          <-  Sp '!='
]]

grammar 'Operator' [[
ADD         <-  Sp '+'
SUB         <-  Sp '-'
MUL         <-  Sp '*'
DIV         <-  Sp '/'
NEG         <-  Sp '-'
]]

grammar 'Paren' [[
PL          <-  Sp '('
PR          <-  Sp ')'
BL          <-  Sp '['
BR          <-  Sp ']'
]]

grammar 'Exp' [[
Exp         <-  ECheckAnd
ECheckAnd   <-  EAnd  -> Binary
ECheckOr    <-  EOr   -> Binary
ECheckComp  <-  EComp -> Binary
ECheckNot   <-  ENot  -> Unary / ECheckAdd
ECheckAdd   <-  EAdd  -> Binary
ECheckMul   <-  EMul  -> Binary

EAnd        <-  ECheckOr   (ESAnd    ECheckOr  )*
EOr         <-  ECheckComp (ESOr     ECheckComp)*
EComp       <-  ECheckNot  (ESComp   ECheckNot )*
ENot        <-              ESNot+   ECheckAdd
EAdd        <-  ECheckMul  (ESAddSub ECheckMul )*
EMul        <-  EUnit      (ESMulDiv EUnit     )*

ESAnd       <-  AND -> 'and'
ESOr        <-  OR  -> 'or'
ESComp      <-  UE  -> '!='
            /   EQ  -> '=='
            /   LE  -> '<='
            /   LT  -> '<' 
            /   GE  -> '>='
            /   GT  -> '>'
ESNot       <-  NOT -> 'not'
ESAddSub    <-  ADD -> '+'
            /   SUB -> '-'
ESMulDiv    <-  MUL -> '*'
            /   DIV -> '/'

EUnit       <-  EParen / ECode / ECall / EValue / ENeg

EParen      <-  PL Exp PR

ECode       <-  {|
                    {:type: '' -> 'code' :}
                    FUNCTION ECodeFunc
                |}
ECodeFunc   <-  {:name: Name :}

ECall       <-  {|
                    {:type: '' -> 'call' :}
                    ECallFunc PL ECallArgs? PR
                |}
                -- TODO 先匹配右括号可以提升性能？
ECallFunc   <-  {:name: Name :}
ECallArgs   <-  {: Exp :} (COMMA {: Exp :})*

EValue      <-  Value / EVari / EVar

EVari       <-  {|
                    {:type: '' -> 'vari' :}
                    EVarName BL EVarIndex BR
                |}
EVarIndex   <-  {: Exp :}

EVar        <-  {|
                    {:type: '' -> 'var' :}
                    EVarName
                |}
EVarName    <-  {:name: Name :}

ENeg        <-  {|
                    {:type: '' -> 'neg' :}
                    NEG EUnit
                |}
]]

grammar 'Type' [[
Type        <-  {|
                    {:type: '' -> 'type' :}
                    {:file: '' ->  File  :}
                    {:line: '' ->  Line  :}
                    TYPE TChild EXTENDS TParent
                |}
TChild      <-  {:name:    Name :}
TParent     <-  {:extends: Name :}
]]

grammar 'Globals' [[
Globals     <-  {|
                    {:type: '' -> 'globals' :}
                    {:file: '' ->  File     :}
                    {:line: '' ->  Line     :}
                    GGlobals
                        Global*
                    GEnd
                |}
Global      <-  {|
                    {:file: '' ->  File :}
                    {:line: '' ->  Line :}
                    (GConstant? GType GArray? GName GExp?)? Nl
                |}
GConstant   <-  {:constant: CONSTANT -> True :}
GArray      <-  {:array:    ARRAY    -> True :}
GType       <-  {:type: Name :}
GName       <-  {:name: Name :}
GExp        <-  ASSIGN {: Exp :}
GGlobals    <-  GLOBALS Nl
GEnd        <-  ENDGLOBALS
]]

grammar 'Local' [[
Local       <-  {|
                    {:file: '' ->  File :}
                    {:line: '' ->  Line :}
                    LOCAL LType LArray? LName LExp?
                |}
Locals      <-  (Local? Nl)+

LType       <-  {:type: Name :}
LName       <-  {:name: Name :}
LArray      <-  {:array: ARRAY -> True :}
LExp        <-  ASSIGN {: Exp :}
]]

grammar 'Action' [[
Action      <-  {|
                    {:file: '' ->  File :}
                    {:line: '' ->  Line :}
                    (ACall / ASet / ASeti / AReturn / AExit / ALogic / ALoop)
                |}
Actions     <-  (Action? Nl)+

ACall       <-  CALL ACallFunc PL ACallArgs? PR
                {:type: '' -> 'call' :}
                -- TODO 先匹配右括号可以提升性能？
                
ACallFunc   <-  {:name: Name :}
ACallArgs   <-  {: Exp :} (COMMA {: Exp :})*

ASet        <-  SET ASetName ASSIGN ASetValue
                {:type: '' -> 'set' :}
ASetName    <-  {:name: Name :}
ASetValue   <-  {: Exp :}

ASeti       <-  SET ASetiName BL ASetiIndex BR ASSIGN ASetiValue
                {:type: '' -> 'seti' :}
ASetiName   <-  {:name: Name :}
ASetiIndex  <-  {: Exp :}
ASetiValue  <-  {: Exp :}

AReturn     <-  RETURN AReturnExp?
                {:type: '' -> 'return' :}
AReturnExp  <-  {: Exp :}

AExit       <-  EXITWHEN AExitExp
                {:type: '' -> 'exit' :}
AExitExp    <-  {: Exp :}

ALogic      <-  LIf
                LElseif*
                LElse?
                LEnd
                {:type:    '' -> 'if'  :}
                {:endline: '' ->  Line :}
LIf         <-  {|
                    {:type: '' -> 'if'  :}
                    {:file: '' ->  File :}
                    {:line: '' ->  Line :}
                    IF LCondition THEN Nl
                        Actions?
                |}
LElseif     <-  {|
                    {:type: '' -> 'elseif' :}
                    {:file: '' ->  File    :}
                    {:line: '' ->  Line    :}
                    ELSEIF LCondition THEN Nl
                        Actions?
                |}
LElse       <-  {|
                    {:type: '' -> 'else' :}
                    {:file: '' ->  File  :}
                    {:line: '' ->  Line  :}
                    ELSE            Nl
                        Actions?
                |}
LEnd        <-  ENDIF
LCondition  <-  {:condition: Exp :}

ALoop       <-  LOOP Nl
                    Actions?
                LoopEnd
                {:type:    '' -> 'loop' :}
                {:endline: '' ->  Line  :}
LoopEnd     <-  ENDLOOP
]]

grammar 'Native' [[
Native      <-  {|
                    {:type:   '' -> 'function' :}
                    {:native: '' ->  True      :}
                    {:file:   '' ->  File      :}
                    {:line:   '' ->  Line      :}
                    NConstant? NATIVE NName NTakes NReturns
                |}
NConstant   <-  {:constant: CONSTANT -> True :}
NName       <-  {:name: Name :}
NTakes      <-  TAKES (NOTHING / {:args: NArgs :})
NArgs       <-  {| NArg (COMMA NArg)* |}
NArg        <-  {|
                    {:type: Name :}
                    {:name: Name :}
                |}
NReturns    <-  RETURNS (NOTHING / {:returns: Name :})
]]

grammar 'Function' [[
Function    <-  {|
                    {:type:    '' -> 'function' :}
                    {:file:    '' ->  File      :}
                    {:line:    '' ->  Line      :}
                    FConstant? FUNCTION FName FTakes FReturns
                        FLocals?
                        Actions?
                    FEnd
                    {:endline: '' ->  Line      :}
                |}
FConstant   <-  {:constant: CONSTANT -> True :}
FName       <-  {:name: Name :}
FTakes      <-  TAKES (NOTHING / {:args: FArgs :})
FArgs       <-  {| FArg (COMMA FArg)* |}
FArg        <-  {|
                    {:type: Name :}
                    {:name: Name :}
                |}
FReturns    <-  RETURNS (NOTHING / {:returns: Name :}) Nl
FLocals     <-  {:locals: {| Locals |} :}
FEnd        <-  ENDFUNCTION
]]

grammar 'Jass' [[
Jass        <-  {| Nl? Chunk? (Nl Chunk)* Nl? Sp |}
Chunk       <-  Type / Globals / Native / Function
]]

local mt = {}
setmetatable(mt, mt)

local function errorpos(jass, file, pos, err)
    local line, col = re.calcline(jass, pos)
    local sp = col - 1
    local start  = jass:find('[^\r\n]', pos-sp) or pos
    local finish = jass:find('[\r\n]', pos+1)
    if finish then
        finish = finish - 1
    else
        finish = #jass
    end
    local text = ('%s\r\n%s^'):format(jass:sub(start, finish), (' '):rep(sp))
    error(lang.parser.ERROR_POS:format(err, file, line, text))
end

function mt:__call(jass, file_, mode)
    file = file_
    linecount = 1
    comments = {}
    local r, e, pos = compiled[mode]:match(jass)
    if not r then
        errorpos(jass, file, pos, lang.PARSER[e])
    end

    return r, comments
end

return mt
