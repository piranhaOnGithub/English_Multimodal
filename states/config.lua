local config = {}

function config:init()
    self.buttons = {
        Button((VIRT_WIDTH / 4) * 3 - 50, VIRT_HEIGHT / 4 - 15, 100, 30, 'back', function()
            State.pop()
        end),
    }
end

function config:enter()
    lg.setBackgroundColor(Colors[11])
end

function config:update(dt)
    for _, b in ipairs(self.buttons) do
        b:update(dt)
    end
end

function config:keypressed(key, code)

end

function config:mousepressed(x, y, mbutton)
    local mx, my = Resolution.toGame(x, y)
    for _, b in ipairs(self.buttons) do
        b:click(mx, my, mbutton)
    end
end

function config:draw()
    lg.setColor(Colors[1])
    lg.setFont(Fonts.monospace[24])
    lg.printf("Settings", 0, VIRT_HEIGHT / 2, VIRT_WIDTH, 'center')

    for _, b in ipairs(self.buttons) do
        b:render()
    end
end

return config
