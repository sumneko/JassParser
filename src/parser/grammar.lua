local re = require 'parser.relabel'
local m = require 'lpeglabel'
local lang = require 'lang'
local calcline = require 'parser.calcline'

local scriptBuf = ''
local compiled = {}
local parser

local defs = setmetatable({}, {__index = function (self, key)
    self[key] = function (...)
        if parser[key] then
            return parser[key](...)
        end
    end
    return self[key]
end})

defs.nl = (m.P'\r\n' + m.S'\r\n') / function ()
    if parser.nl then
        return parser.nl()
    end
end
function defs.Nil()
    return nil
end
function defs.Fail()
    return false
end
defs.True = m.Cc(true)
defs.False = m.Cc(false)
defs.s  = m.S' \t' + m.P'\xEF\xBB\xBF'
defs.S  = - defs.s
defs.eb = '\b'
defs.et = '\t'
defs.er = '\r'
defs.en = '\n'
defs.ef = '\f'
defs.ExChar = m.R'\0\8' + m.R'\11\12' + m.R'\14\31' + m.R'\127\255'
local eof = re.compile '!. / %{SYNTAX_ERROR}'

local function grammar(tag)
    return function (script)
        scriptBuf = script .. '\r\n' .. scriptBuf
        compiled[tag] = re.compile(scriptBuf, defs) * eof
    end
end

grammar 'Comment' [[
Comment     <-  '//' [^%nl]* -> Comment
]]

grammar 'Sp' [[
Sp          <-  (Comment / %s)* ExChar?
ExChar      <-  &%ExChar %{EXCEPTION_CHAR}
]]

grammar 'Nl' [[
Nl          <-  (Sp %nl)+
Ignore      <-  [^%nl]*
]]

grammar 'Common' [[
Cut         <-  ![a-zA-Z0-9_]
Ed          <-  Sp (&Nl / !.)
COMMA       <-  Sp ','
ASSIGN      <-  Sp '='
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
RETURNS     <-  Sp ('returns' / 'return' -> returnAsReturns) Cut
CALL        <-  Sp ('call' / 'set' -> setAsCall) Cut
SET         <-  Sp ('set' / 'call' -> callAsSet) Cut
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

grammar 'Esc' [[
Esc         <-  '\' {EChar}
EChar       <-  'b' -> eb
            /   't' -> et
            /   'r' -> er
            /   'n' -> en
            /   'f' -> ef
            /   '"'
            /   '\'
            /   %{ERROR_ESC}
]]

grammar 'Value' [[
Value       <-  NULL / Boolean / String / Real / Integer
NULL        <-  Sp 'null' Cut
            ->  NULL

Boolean     <-  TRUE  -> TRUE
            /   FALSE -> FALSE

String      <-  Sp '"' {(Esc / %nl / [^"])*} -> String '"'

Real        <-  Sp ('-'? Sp ('.' [0-9]+^ERROR_REAL / [0-9]+ '.' [0-9]*))
            ->  Real

Integer     <-  Integer16 / Integer8 / Integer10 / Integer256
Integer8    <-  Sp ({'-'?} Sp {'0' [0-9]*})
            ->  Integer8
Integer10   <-  Sp ({'-'?} Sp {'0' / ([1-9] [0-9]*)})
            ->  Integer10
Integer16   <-  Sp ({'-'?} Sp ('$' / '0x' / '0X') {Char16})
            ->  Integer16
Char16      <-  [a-fA-F0-9]+^ERROR_INT16
Integer256  <-  Sp ({'-'?} Sp C256)
            ->  Integer256
C256        <-  "'" {C256_1} "'"
            /   "'" {C256_4 C256_4 C256_4 C256_4} "'"
            /   "'" %{ERROR_INT256_COUNT}
C256_1      <-  Esc / %nl / [^']
C256_4      <-  %nl / [^']
]]

grammar 'Name' [[
Name        <-  Sp {[a-zA-Z] [a-zA-Z0-9_]*}
]]

grammar 'Compare' [[
GT          <-  '>'
GE          <-  '>='
LT          <-  '<'
LE          <-  '<='
EQ          <-  '=='
UE          <-  '!='
]]

grammar 'Operator' [[
ADD         <-  '+'
SUB         <-  '-'
MUL         <-  '*'
DIV         <-  '/'
]]

grammar 'Paren' [[
PL          <-  Sp '('
PR          <-  Sp ')'
BL          <-  Sp '['
BR          <-  Sp ']'
]]

grammar 'Exp' [[
Exp         <-  ECheckAnd
ECheckAnd   <-  (ECheckOr   (Sp ESAnd    ECheckOr  ^ERROR_MISS_EXP)*) -> Binary
ECheckOr    <-  (ECheckComp (Sp ESOr     ECheckComp^ERROR_MISS_EXP)*) -> Binary
ECheckComp  <-  (ECheckNot  (Sp ESComp   ECheckNot ^ERROR_MISS_EXP)*) -> Binary
ECheckNot   <-  (            Sp ESNot+   ECheckAdd ^ERROR_MISS_EXP  ) -> Unary / ECheckAdd
ECheckAdd   <-  (ECheckMul  (Sp ESAddSub ECheckMul ^ERROR_MISS_EXP)*) -> Binary
ECheckMul   <-  (EUnit      (Sp ESMulDiv EUnit     ^ERROR_MISS_EXP)*) -> Binary

ESAnd       <-  AND -> 'and'
ESOr        <-  OR  -> 'or'
ESComp      <-  UE  -> '!='
            /   EQ  -> '=='
            /   LE  -> '<='
            /   LT  -> '<' 
            /   GE  -> '>='
            /   GT  -> '>'
            -- 收集错误
            /   Sp '=' -> '='
ESNot       <-  NOT -> 'not'
ESAddSub    <-  ADD -> '+'
            /   SUB -> '-'
ESMulDiv    <-  MUL -> '*'
            /   DIV -> '/'

EUnit       <-  EParen / ECode / ECall / EValue / ENeg

EParen      <-  PL Exp PR^ERROR_MISS_PR

ECode       <-  FUNCTION Name
            ->  Code

ECall       <-  (Name PL ECallArgs? PR^ERROR_MISS_PR)
            ->  ECall
ECallArgs   <-  Exp (COMMA Exp)*

EValue      <-  Value / EVari / EVar

EVari       <-  (Name BL Exp BR)
            ->  Vari

EVar        <-  Name
            ->  Var

ENeg        <-  Sp SUB EUnit
            ->  Neg
]]

grammar 'Type' [[
Type        <-  (TYPE TChild TExtends TParent)
            ->  Type
TChild      <-  Name   ^ERROR_VAR_TYPE
TExtends    <-  EXTENDS^ERROR_EXTENDS_TYPE
TParent     <-  Name   ^ERROR_EXTENDS_TYPE
]]

grammar 'Globals' [[
Globals     <-  {} -> GlobalsStart
                GLOBALS Nl^MISS_NL
                    {| (Global? Nl)* |} -> Globals
                ENDGLOBALS^ERROR_ENDGLOBALS
                {} -> GlobalsEnd
Global      <-  ({CONSTANT?} Name {ARRAY?} Name (ASSIGN Exp)?)
            ->  Global
]]

grammar 'Local' [[
Local       <-  ((CONSTANT -> constantLocal)? LOCAL Name {ARRAY?} Name (ASSIGN Exp)?)
            ->  Local
            /   TYPE Ignore
            ->  typeInFunction
Locals      <-  (Local? Nl)+
]]

grammar 'Action' [[
Action      <-  (
                    {} -> Point
                    (ACall / ASet / ASeti / AReturn / AExit / ALogic / ALoop / AError)
                )
            ->  Action
Actions     <-  (Action? Nl)+

ACall       <-  (CALL Name PL ACallArgs? PR^ERROR_MISS_PR)
            ->  ACall
ACallArgs   <-  Exp (COMMA Exp)*

ASet        <-  (SET Name ASSIGN Exp)
            ->  Set

ASeti       <-  (SET Name BL Exp BR ASSIGN Exp)
            ->  Seti

AReturn     <-  RETURN (ARExp Ed / Sp %{SYNTAX_ERROR})
ARExp       <-  Ed  -> Return
            /   Exp -> ReturnExp Ed

AExit       <-  EXITWHEN Exp
            ->  Exit

ALogic      <-  (
                    LIf
                    LElseif*
                    LElse?
                    LEnd
                )
            ->  Logic
LIf         <-  (
                    {} -> IfStart
                    IF (Exp THEN)^ERROR_MISS_THEN Nl
                        (Actions?)
                )
            ->  If
LElseif     <-  (
                    {} -> ElseifStart
                    ELSEIF (Exp THEN)^ERROR_MISS_THEN Nl
                        (Actions?)
                )
            ->  Elseif
LElse       <-  (
                    {} -> ElseStart
                    ELSE Nl
                        (Actions?)
                )
            ->  Else
LEnd        <-  ENDIF^ERROR_ENDIF
            ->  Endif

ALoop       <-  (
                    LOOP Nl -> LoopStart
                        {} Actions?
                    ENDLOOP -> LoopEnd
                )
            ->  Loop

AError      <-  LOCAL Ignore
            ->  localInFunction
            /   TYPE Ignore
            ->  typeInFunction
]]

grammar 'Native' [[
Native      <-  (
                    {} -> Point
                    {CONSTANT?} NATIVE Name NTakes NReturns
                )
            ->  Native
NTakes      <-  TAKES (NOTHING -> Nil / (NArg (COMMA NArg)*) -> NArgs)
NArg        <-  Name Name
NReturns    <-  RETURNS^SYNTAX_ERROR (NOTHING -> Nil / Name)
]]

grammar 'Function' [[
Function    <-  FDef -> FunctionStart Nl
                (
                    FLocals
                    {|Actions?|}
                ) -> FunctionBody
                FEnd -> FunctionEnd
FDef        <-  {CONSTANT?} FUNCTION (Name FTakes FReturns)^SYNTAX_ERROR
FTakes      <-  TAKES^SYNTAX_ERROR (NOTHING -> Nil / (NArg (COMMA NArg)*) -> FArgs / Sp %{SYNTAX_ERROR})
FArg        <-  Name Name
FReturns    <-  RETURNS^SYNTAX_ERROR (NOTHING -> Nil / Name)
FLocals     <-  {|Locals|} / {} -> Nil
FEnd        <-  ENDFUNCTION^ERROR_ENDFUNCTION
]]

grammar 'Jass' [[
Jass        <-  ({} Nl? Chunk? (Nl Chunk)* Nl? Sp)
            ->  Jass
Chunk       <-  (   Type
                /   Globals
                /   Native
                /   Function
                -- 错误收集
                /   Action %{ERROR_ACTION_IN_CHUNK}
                )
            ->  Chunk
]]

local function errorpos(jass, file, pos, err)
    local nl
    if jass:sub(pos, pos):find '[\r\n]' and jass:sub(pos-1, pos-1):find '[^\r\n]' then
        pos = pos - 1
        nl = true
    end
    local line, col, str = calcline(jass, pos)
    local sp = col - 1
    if nl or pos > #jass then
        sp = sp + 1
    end
    local spc = ''
    for i = 1, sp do
        if str:sub(i, i) == '\t' then
            spc = spc .. '\t'
        else
            spc = spc .. ' '
        end
    end
    local text = ('%s\r\n%s^'):format(str, spc)
    local err = {
        msg = lang.parser.ERROR_POS:format(err, file, line, text),
        jass = jass,
        file = file,
        line = line,
        pos = sp+1,
        err = err,
        level = 'error',
    }
    return err
end

return function (jass, file_, mode, parser_)
    file = file_
    parser = parser_ or {}
    local r, e, pos = compiled[mode]:match(jass)
    if not r then
        local err = errorpos(jass, file, pos, lang.PARSER[e])
        return nil, err
    end

    return r
end
