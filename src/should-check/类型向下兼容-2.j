type agent extends handle

native Agent takes nothing returns agent

function test takes handle h returns nothing
    call test(Agent())
endfunction