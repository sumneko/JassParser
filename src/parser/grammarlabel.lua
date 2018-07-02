local re = require 'parser.relabel'
local m = require 'lpeglabel'

local scriptBuf = ''
local compiled = {}

local defs = {}
defs.nl = m.P'\r\n' + m.S'\r\n'
defs.s  = m.S' \t' + m.P'\xEF\xBB\xBF'
defs.S  = - defs.s

local function grammar(tag)
    return function (script)
        scriptBuf = script .. '\r\n' .. scriptBuf
        print('compiling: ' .. tag)
        compiled[tag] = re.compile(scriptBuf, defs)
    end
end

grammar 'Comment' [[
Comment     <- '//' [^%nl]*
]]

grammar 'Sp' [[
Sp          <- (%s / Comment)*
]]

grammar 'Nl' [[
Nl          <- Sp %nl
]]

grammar 'Common' [[
RESERVED    <- GLOBALS / ENDGLOBALS / CONSTANT / NATIVE / ARRAY / AND / OR / NOT / TYPE / EXTENDS / FUNCTION / ENDFUNCTION / NOTHING / TAKES / RETURNS / CALL / SET / RETURN / IF / ENDIF / ELSEIF / ELSE / LOOP / ENDLOOP / EXITWHEN
Cut         <- ![a-zA-Z0-9_]
COMMA       <- Sp ','
ASSIGN      <- Sp '=' !'='
GLOBALS     <- Sp 'globals' Cut
ENDGLOBALS  <- Sp 'endglobals' Cut
CONSTANT    <- Sp 'constant' Cut
NATIVE      <- Sp 'native' Cut
ARRAY       <- Sp 'array' Cut
AND         <- Sp 'and' Cut
OR          <- Sp 'or' Cut
NOT         <- Sp 'not' Cut
TYPE        <- Sp 'type' Cut
EXTENDS     <- Sp 'extends' Cut
FUNCTION    <- Sp 'function' Cut
ENDFUNCTION <- Sp 'endfunction' Cut
NOTHING     <- Sp 'nothing' Cut
TAKES       <- Sp 'takes' Cut
RETURNS     <- Sp 'returns' Cut
CALL        <- Sp 'call' Cut
SET         <- Sp 'set' Cut
RETURN      <- Sp 'return' Cut
IF          <- Sp 'if' Cut
THEN        <- Sp 'then' Cut
ENDIF       <- Sp 'endif' Cut
ELSEIF      <- Sp 'elseif' Cut
ELSE        <- Sp 'else' Cut
LOOP        <- Sp 'loop' Cut
ENDLOOP     <- Sp 'endloop' Cut
EXITWHEN    <- Sp 'exitwhen' Cut
LOCAL       <- Sp 'local' Cut
]]

grammar 'Value' [[
Value       <- NULL / Boolean / String / Real / Integer
NULL        <- Sp 'null' Cut
Boolean     <- Sp ('true' / 'false') Cut
String      <- Sp '"' ('\\' / '\"' / (!'"' .))* '"'
Real        <- Sp '-'? Sp ('.' [0-9]+) / ([0-9]+ '.' [0-9]*)
Integer     <- Integer16 / Integer10 / Integer256
Integer10   <- Sp '-'? Sp ('0' / ([1-9] [0-9]*))
Integer16   <- Sp '-'? Sp ('$' / '0x' / '0X') [a-fA-F0-9]+
Integer256  <- Sp '-'? Sp "'" ('\\' / "\'" / (!"'" .))* "'"
]]

grammar 'Name' [[
Name        <- !RESERVED Sp [a-zA-Z] [a-zA-Z0-9_]*
]]

grammar 'Word' [[
Word        <- Value / Name
]]

grammar 'Compare' [[
Compare     <- UE / EQ / LE / LT / GE / GT
GT          <- Sp '>'
GE          <- Sp '>='
LT          <- Sp '<'
LE          <- Sp '<='
EQ          <- Sp '=='
UE          <- Sp '!='
]]

grammar 'Operator' [[
ADD         <- Sp '+'
SUB         <- Sp '-'
MUL         <- Sp '*'
DIV         <- Sp '/'
NEG         <- Sp '-'
]]

grammar 'Paren' [[
PL          <- Sp '('
PR          <- Sp ')'
BL          <- Sp '['
BR          <- Sp ']'
]]

grammar 'Exp' [[
Exp         <- EAnd
EAnd        <- EOr      (AND         EOr)*
EOr         <- ECompare (OR          ECompare)*
ECompare    <- ENot     (Compare     ENot)*
ENot        <-           NOT*        EAdd
EAdd        <- EMul     ((ADD / SUB) EMul)*
EMul        <- EUnit    ((MUL / DIV) EUnit)*
EUnit       <- EParen / ECode / ECall / EValue / ENeg

EParen      <- PL Exp PR

ECode       <- FUNCTION ECodeFunc
ECodeFunc   <- Name

ECall       <- ECallFunc PL ECallArgs PR
ECallFunc   <- Name
ECallArgs   <- ECallArg (COMMA ECallArg)*
ECallArg    <- Exp

EValue      <- EVari / EVar / EWord
EVari       <- EVar BL EIndex BR
EIndex      <- Exp
EVar        <- Name
EWord       <- Word

ENeg        <- NEG EUnit
]]

grammar 'Type' [[
Type        <- TYPE TChild EXTENDS TParent
TChild      <- Name
TParent     <- Name
]]

grammar 'Globals' [[
Globals     <- GLOBALS Global* GEnd
Global      <- Nl GConstant? GType GArray? GName GExp?
GConstant   <- CONSTANT
GType       <- Name
GArray      <- ARRAY
GName       <- Name
GExp        <- ASSIGN Exp
GEnd        <- Nl ENDGLOBALS
]]

grammar 'Local' [[
Local       <- Nl LOCAL LType LArray? LName LExp?
Locals      <- Local*

LType       <- Name
LArray      <- ARRAY
LName       <- Name
LExp        <- ASSIGN Exp
]]

grammar 'Action' [[
Action      <- ACall / ASet / ASeti / AReturn / AExit / ALogic / ALoop
Actions     <- (Nl Action)*

ACall       <- CALL ACallFunc PL ACallArgs PR
ACallFunc   <- Name
ACallArgs   <- Exp (COMMA ACallArg)*
ACallArg    <- Exp

ASet        <- SET ASetName ASSIGN ASetValue
ASetName    <- Name
ASetValue   <- Exp

ASeti       <- SET ASetiName BL ASetiIndex BR ASSIGN ASetiValue
ASetiName   <- Name
ASetiIndex  <- Exp
ASetiValue  <- Exp

AReturn     <- RETURN AReturnExp?
AReturnExp  <- Exp

AExit       <- EXITWHEN AExitExp
AExitExp    <- Exp

ALogic      <- LIf LElseif* LElse? LEnd
LIf         <- IF        Exp THEN Actions
LElseif     <- Nl ELSEIF Exp THEN Actions
LElse       <- Nl ELSE            Actions
LEnd        <- Nl ENDIF

ALoop       <- LOOP Actions LoopEnd
LoopEnd     <- Nl ENDLOOP
]]

grammar 'Native' [[
Native      <- NConstant? NATIVE NName NTakes NReturns
NConstant   <- CONSTANT
NName       <- Name
NTakes      <- TAKES (NTNothing / NArgs)
NTNothing   <- NOTHING
NArgs       <- NArg (COMMA NArg)*
NArg        <- NArgType NArgName
NArgType    <- Name
NArgName    <- Name
NReturns    <- RETURNS (NRNothing / NRExp)
NRNothing   <- NOTHING
NRExp       <- Exp
]]

grammar 'Function' [[
Function    <- FConstant? FUNCTION FName FTakes FReturns FLocals FActions 
Functions   <- Function (Nl Function)*FEnd
FConstant   <- CONSTANT
FName       <- Name
FTakes      <- TAKES (FTNothing / FArgs)
FTNothing   <- NOTHING
FArgs       <- FArg (COMMA FArg)*
FArg        <- FArgType FArgName
FArgType    <- Name
FArgName    <- Name
FReturns    <- RETURNS (FRNothing / FRExp)
FRNothing   <- NOTHING
FRExp       <- Exp
FLocals     <- Locals
FActions    <- Actions
FEnd        <- Nl ENDFUNCTION
]]

grammar 'Jass' [[
Jass        <- Nl? Chunk (Nl Chunk)* Nl?
Chunk       <- Type / Globals / Native / Function
]]

local mt = {}
setmetatable(mt, mt)

function mt:__call(jass, file, mode)
    print('File: ', file)
    print('Mode: ', mode)
    local comments = {}
    local r, e, pos = compiled[mode]:match(jass)
    if not r then
        local line, col = re.calcline(jass, pos)
        local msg = "Error at line " .. line .. " (col " .. col .. "): "
        error(msg .. e)
    end

    return r, comments
end

return mt
