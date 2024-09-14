
local toggle = {
    fullscreen = false,
}

love.load = function()

    -- Load all dependencies
    require 'src.dependencies'

    -- Set up the window
    Resolution.init({
        width   = VIRT_WIDTH,
        height  = VIRT_HEIGHT,
        mode    = 1,
        bars    = true
    })
    Resolution.nearestFilter(true)

    -- Set a random seed
    math.randomseed(os.time())

    -- Insert every callback except for draw
    local callbacks = {'update'}
    for k in pairs(love.handlers) do
        callbacks[#callbacks+1] = k
    end

    -- Enter gamestate
    State.registerEvents(callbacks)
    State.switch(States.start)
end

love.update = function(dt)

end

love.resize = function(w, h)
    Resolution.resize(w, h)
end

love.draw = function()
    -- Scale current state to window
    Resolution.start()

    State.current():draw()

    Resolution.stop()

    -- DEBUGGING
    if DEBUG then
        local text = 'Debug World!'

        local stats = lg.getStats()
        local info = {
            'FPS: ' .. lt.getFPS(),
            'MOUSE: X: ' ..
            Lume.round(Resolution.toGameX(lm.getX())) .. ', Y: ' ..
            Lume.round(Resolution.toGameY(lm.getY())),
            'RAM: ' .. tostring(Lume.round((collectgarbage)('count'), 0.1)) .. 'KB',
            'VRAM: ' .. tostring(Lume.round((stats.texturememory / 1024), 0.1)) .. 'KB',
            'DRAW CALLS: ' .. stats.drawcalls,
            'IMAGES: ' .. stats.images,
            'CANVASES: ' .. stats.canvases,
            'FONTS: ' .. stats.fonts,
        }

        for i in ipairs(info) do
            text = text .. '\n' .. info[i]
        end

        lg.setFont(Fonts.monospace[11])
        lg.setColor(0, 0, 0, 1)
        lg.print(text, 11, 11)
        lg.setColor(1, 1, 1, 1)
        lg.print(text, 10, 10)
    end
end

love.keypressed = function(key)
    if key == "escape" then
        love.event.quit()
    end
    if key == "lctrl" then
        DEBUG = not DEBUG
    end
    if key == "rctrl" then
        love.event.quit("restart")
    end
    if key == "f11" then
        toggle.fullscreen = not toggle.fullscreen
        love.window.setFullscreen(toggle.fullscreen)
    end
end