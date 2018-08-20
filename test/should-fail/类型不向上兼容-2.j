type agent extends handle

native Handle takes nothing returns handle

function test takes agent h returns nothing
    call test(Handle())
endfunction