type agent extends handle

native Handle takes nothing returns handle

function test takes nothing returns nothing
    local agent h
    set h = Handle()
endfunction