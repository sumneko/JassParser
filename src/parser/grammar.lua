local re = require 'parser.relabel'
local m = require 'lpeglabel'
local lang = require 'lang'

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
defs.True = m.Cc(true)
defs.False = m.Cc(false)
defs.s  = m.S' \t' + m.P'\xEF\xBB\xBF'
defs.S  = - defs.s
defs.eb = '\b'
defs.et = '\t'
defs.er = '\r'
defs.en = '\n'
defs.ef = '\f'
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
Sp          <-  (Comment / %s)*
]]

grammar 'Nl' [[
Nl          <-  (Sp %nl)+
]]

grammar 'Common' [[
Cut         <-  ![a-zA-Z0-9_]
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

Integer     <-  Integer16 / Integer10 / Integer256
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
ECheckAnd   <-  (ECheckOr   (ESAnd    ECheckOr  )*) -> Binary
ECheckOr    <-  (ECheckComp (ESOr     ECheckComp)*) -> Binary
ECheckComp  <-  (ECheckNot  (ESComp   ECheckNot )*) -> Binary
ECheckNot   <-  (            ESNot+   ECheckAdd   ) -> Unary / ECheckAdd
ECheckAdd   <-  (ECheckMul  (ESAddSub ECheckMul )*) -> Binary
ECheckMul   <-  (EUnit      (ESMulDiv EUnit     )*) -> Binary

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

ECode       <-  FUNCTION Name
            ->  Code

ECall       <-  (Name PL ECallArgs? PR)
            ->  ECall
ECallArgs   <-  Exp (COMMA Exp)*

EValue      <-  Value / EVari / EVar

EVari       <-  (Name BL Exp BR)
            ->  Vari

EVar        <-  Name
            ->  Var

ENeg        <-  NEG EUnit
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
                GLOBALS Nl
                    {| (Global? Nl)* |} -> Globals
                ENDGLOBALS^ERROR_ENDGLOBALS
                {} -> GlobalsEnd
Global      <-  ({CONSTANT?} Name {ARRAY?} Name (ASSIGN Exp)?)
            ->  Global
]]

grammar 'Local' [[
Local       <-  (LOCAL Name {ARRAY?} Name (ASSIGN Exp)?)
            ->  Local
Locals      <-  (Local? Nl)+
]]

grammar 'Action' [[
Action      <-  (
                    {} -> Point
                    (ACall / ASet / ASeti / AReturn / AExit / ALogic / ALoop)
                )
            ->  Action
Actions     <-  (Action? Nl)+

ACall       <-  (CALL Name PL ACallArgs? PR)
            ->  ACall
ACallArgs   <-  Exp (COMMA Exp)*

ASet        <-  (SET Name ASSIGN Exp)
            ->  Set

ASeti       <-  (SET Name BL Exp BR ASSIGN Exp)
            ->  Seti

AReturn     <-  ({} RETURN Exp?)
            ->  Return

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
                    {} -> Point
                    IF Exp THEN Nl
                        (Actions?)
                )
            ->  If
LElseif     <-  (
                    {} -> Point
                    ELSEIF Exp THEN Nl
                        (Actions?)
                )
            ->  Elseif
LElse       <-  (
                    {} -> Point
                    ELSE Nl
                        (Actions?)
                )
            ->  Else
LEnd        <-  ENDIF

ALoop       <-  (
                    LOOP Nl -> LoopStart
                        {} Actions?
                    ENDLOOP -> LoopEnd
                )
            ->  Loop
]]

grammar 'Native' [[
Native      <-  (
                    {} -> Point
                    {CONSTANT?} NATIVE Name NTakes NReturns
                )
            ->  Native
NTakes      <-  TAKES (NOTHING -> Nil / (NArg (COMMA NArg)*) -> NArgs)
NArg        <-  Name Name
NReturns    <-  RETURNS (NOTHING -> Nil / Name)
]]

grammar 'Function' [[
Function    <-  FDef -> FunctionStart Nl
                    (FLocals {|Actions?|}) -> FunctionBody
                FEnd -> FunctionEnd
FDef        <-  {CONSTANT?} FUNCTION Name FTakes FReturns
FTakes      <-  TAKES (NOTHING -> Nil / (NArg (COMMA NArg)*) -> FArgs)
FArg        <-  Name Name
FReturns    <-  RETURNS (NOTHING -> Nil / Name)
FLocals     <-  {|Locals|} / {} -> Nil
FEnd        <-  ENDFUNCTION^ERROR_ENDFUNCTION
]]

grammar 'Jass' [[
Jass        <-  ({} Nl? Chunk? (Nl Chunk)* Nl? Sp)
            ->  Jass
Chunk       <-  (Type / Globals / Native / Function)
            ->  Chunk
]]

local function errorpos(jass, file, pos, err)
    local nl
    if jass:sub(pos, pos):find '[\r\n]' and jass:sub(pos-1, pos-1):find '[^\r\n]' then
        pos = pos - 1
        nl = true
    end
    local line, col = re.calcline(jass, pos)
    local sp = col - 1
    if nl or pos > #jass then
        sp = sp + 1
    end
    local start  = jass:find('[^\r\n]', pos-sp) or pos
    local finish = jass:find('[\r\n]', pos+1)
    if finish then
        finish = finish - 1
    else
        finish = #jass
    end
    local text = ('%s\r\n%s^'):format(jass:sub(start, finish), (' '):rep(sp))
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
