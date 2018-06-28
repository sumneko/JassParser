local re = require 'relabel'
local lpeg = require 'lpeglabel'

local scriptBuf = ''
local function grammar(tag)
    return function (script)
        scriptBuf = scriptBuf .. script
    end
end

grammar 'Common' [[
Comment     <- '//' (!%nl)*
Sp          <- (%s / %t / '\xEF\xBB\xBF' / Comment)*
Cut         <- ![a-zA-Z0-9_]+
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
ENDIF       <- Sp 'endif' Cut
ELSEIF      <- Sp 'elseif' Cut
ELSE        <- Sp 'else' Cut
LOOP        <- Sp 'loop' Cut
ENDLOOP     <- Sp 'endloop' Cut
EXITWHEN    <- Sp 'exitwhen' Cut
RESERVED   <- GLOBALS / ENDGLOBALS / CONSTANT / NATIVE / ARRAY / AND / OR / NOT / TYPE / EXTENDS / FUNCTION / ENDFUNCTION / NOTHING / TAKES / RETURNS / CALL / SET / RETURN / IF / ENDIF / ELSEIF / ELSE / LOOP / ENDLOOP / EXITWHEN)
]]

grammar 'Word' [[
Id          <- !RESERVED Sp ([a-zA-Z]) ([a-zA-Z0-9_])*
NULL        <- Sp 'null' Cut
Boolean     <- Sp ('true' / 'false') Cut
String      <- Sp '"' ('\\\\' / '\\"' / !'"')* '"'
Real        <- Sp "-"? Sp ("." [0-9]+) / [0-9]+ "." [0-9]*)
Integer     <- Integer16 / Integer10 / Integer256
Integer10   <- Sp "-"? Sp ("0" / ([1-9] [0-9]*))
Integer16   <- Sp "-"? Sp ("$" / "0x" / "0X") ([a-fA-F0-9])+
Integer256  <- Sp "-"? Sp "'" ("\\\\" / "\\'" / !"'")* "'"
Word        <- NULL / Boolean / String / Real / Integer / Id
]]

grammar 'Compare' [[
GT          <- Sp ">"
GE          <- Sp ">="
LT          <- Sp "<"
LE          <- Sp "<="
EQ          <- Sp "=="
UE          <- Sp "!="
Compare     <- UE / EQ / LE / LT / GE / GT
]]

grammar 'Exp' [[
ExpAnd      <- Sp ExpOr      (AND     ExpOr)*
ExpOr       <- Sp ExpCompare (OR      ExpCompare)*
ExpCompare  <- Sp ExpNot     (Compare ExpNot)*
ExpNot      <- 
]]

local Pjass = re.compile(scriptBuf, terror)

local mt = {}
setmetatable(mt, mt)

function mt:__call(jass, file, mode)
    local r, e, pos = Pjass:match(jass)
    if not r then
        local line, col = re.calcline(s, pos)
        local msg = "Error at line " .. line .. " (col " .. col .. "): "
        return r, msg
    end

    return r
end

return mt
