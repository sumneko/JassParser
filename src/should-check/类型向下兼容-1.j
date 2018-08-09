type agent extends handle

native Agent takes nothing returns agent

function test takes nothing returns nothing
    local handle h = Agent()
endfunction