local gui = require 'yue.gui'
local lpeg = require 'lpeglabel'

local indexhtml = [[
<!DOCTYPE html><html><head><style>%s</style></head><body><script>%s%s</script></script><div class="outer-container"><div class="inner-container"><pre class="line-numbers" data-start="%d"><code class="language-code">%s</code></pre></div></div></body></html>
]]

local function readfile(filename)
    local f = assert(io.open(filename:string(), 'r'))
    local str = f:read 'a'
    f:close()
    return str
end

local nl = lpeg.P'\r\n' + lpeg.S'\r\n'
local function cutline(str, startLn, endLn)
    local res
    local startPos = 0
    local endPos
    local n = 1
    local line = lpeg.Cmt((1 - nl)^0, function (_, pos, c)
        n = n + 1
        if n == startLn then
            startPos = pos
            return true
        elseif n == endLn then
            endPos = pos
            return false
        end
        return true
    end)
    local match = (line * nl)^0 * line
    match:match(str)
    return str:sub(startPos, endPos)
end

local function guiscript(cwd, script, lines)
    --TODO
    local line = tonumber(lines)
    local startLn = (line - 100 < 0) and 1 or line - 100
    local endLn = line + 100
    local script = cutline(script, startLn, endLn)

    local browser = gui.Browser.create{}
    browser.registerprotocol('ydwe', function(url)
        if url == 'ydwe://code/' then
            return gui.ProtocolStringJob.create('text/html', indexhtml:format(
                readfile(cwd / 'prism.css'),
                readfile(cwd / 'prism.js'),
                readfile(cwd / 'highlight.js'),
                startLn, script
            )) 
        end
    end)
    browser:setstyle { FlexGrow = 1 }
    browser:loadurl('ydwe://code#' .. lines)
    return browser
end

local function guilabel(text)
    local label = gui.Label.create(text)
    label:setstyle { MinWidth=540, Left=20 }
    label:setalign 'start'
    return label
end

local function guiclose(win)
    local close = gui.Container.create()
    close:setstyle { Width=40, Height=40 }
    function close:onmouseleave()
        close:setbackgroundcolor('#FFF')
    end
    function close:onmouseenter()
        close:setbackgroundcolor('#BE3246')
    end
    local canvas = gui.Canvas.createformainscreen{width=40, height=40}
    local painter = canvas:getpainter()
    painter:setstrokecolor('#000000')
    painter:beginpath()
    painter:moveto(15, 15)
    painter:lineto(25, 25)
    painter:moveto(15, 25)
    painter:lineto(25, 15)
    painter:closepath()
    painter:stroke()
    function close:onmousedown()
        win:close()
    end
    function close:ondraw(painter, dirty)
        painter:drawcanvas(canvas, {x=0, y=0, width=40, height=40})
    end
    return close
end

local function guiwindow(cwd, message, filename, line)
    local win = gui.Window.create{ frame = false }
    
    local view = gui.Container.create()
    view:setstyle { FlexGrow = 1 }
    view:setmousedowncanmovewindow(true)
    local title = gui.Container.create()
    title:setstyle { Height = 40, FlexDirection = 'row', JustifyContent = 'space-between' }
    title:setmousedowncanmovewindow(true)
    local label = guilabel(message)
    label:setmousedowncanmovewindow(true)
    title:addchildview(label)
    title:addchildview(guiclose(win))
    view:addchildview(title)
    view:addchildview(guiscript(cwd, readfile(filename), tostring(line)))
    
    win:setcontentview(view)
    win:setcontentsize{width=600, height=440}
    win:sethasshadow(true)
    win:setresizable(false)
    win:setmaximizable(false)
    win:setminimizable(false)
    win:setalwaysontop(true)
    win:center()
    win:activate()
    win.onclose = function() gui.MessageLoop.quit() end
    gui.MessageLoop.run()
end

return guiwindow
