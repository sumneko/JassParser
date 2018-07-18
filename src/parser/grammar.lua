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

String      <-  Sp '"' {(Esc / [^"])*} -> String '"'

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
C256_1      <-  Esc
            /   !"'" .
C256_4      <-  Esc %{ERROR_INT256_ESC}
            /   !"'" .
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
            ->  Call
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
Globals     <-  GLOBALS -> GlobalsStart Nl
                    {| (Global? Nl)* |} -> Globals
                ENDGLOBALS -> GlobalsEnd^ERROR_ENDGLOBALS
Global      <-  ({CONSTANT?} Name {ARRAY?} Name (ASSIGN Exp)?)
            ->  Global
]]

grammar 'Local' [[
Local       <-  (LOCAL Name {ARRAY?} Name (ASSIGN Exp)?)
            ->  Local
Locals      <-  (Local? Nl)+
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
                    {:native: '' %True      :}
                    {:file:   '' ->  File      :}
                    {:line:   '' ->  Line      :}
                    NConstant? NATIVE NName NTakes NReturns
                |}
NConstant   <-  {:constant: CONSTANT %True :}
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
FConstant   <-  {:constant: CONSTANT %True :}
FName       <-  {:name: Name :}
FTakes      <-  TAKES (NOTHING / {:args: FArgs :})
FArgs       <-  {| FArg (COMMA FArg)* |}
FArg        <-  {|
                    {:type: Name :}
                    {:name: Name :}
                |}
FReturns    <-  RETURNS (NOTHING / {:returns: Name :}) Nl
FLocals     <-  {:locals: {| Locals |} :}
FEnd        <-  ENDFUNCTION^ERROR_ENDFUNCTION
]]

grammar 'Jass' [[
Jass        <-  {| Nl? Chunk? (Nl Chunk)* Nl? Sp |}
Chunk       <-  Type / Globals / Native / Function
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
    error(lang.parser.ERROR_POS:format(err, file, line, text))
end

return function (jass, file_, mode, parser_)
    file = file_
    parser = parser_ or {}
    local r, e, pos = compiled[mode]:match(jass)
    if not r then
        errorpos(jass, file, pos, lang.PARSER[e])
    end

    return r
end
