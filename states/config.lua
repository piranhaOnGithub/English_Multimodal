local config = {}

function config:init()

end

function config:enter()
    lg.setBackgroundColor(Colors[7])
end

function config:update(dt)

end

function config:keypressed(key, code)

end

function config:mousepressed(x, y, mbutton)

end

function config:draw()
    lg.setColor(Colors[2])
    lg.setFont(Fonts.monospace[24])
    lg.printf("Settings", 0, VIRT_HEIGHT / 2, VIRT_WIDTH, 'center')
end

return config
