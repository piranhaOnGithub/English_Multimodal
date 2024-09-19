local start = {}

function start:init()
    self.num = 1
    self.buttons = {
        Button(VIRT_WIDTH / 2 - 50, VIRT_HEIGHT / 2 - 15, 100, 30, 'game', function()
            State.switch(States.intro)
        end),
        Button(VIRT_WIDTH / 2 - 50, VIRT_HEIGHT / 2 + 30, 100, 30, 'settings', function()
            State.push(States.config)
        end),
        Button(VIRT_WIDTH / 2 - 50, VIRT_HEIGHT / 2 + 75, 100, 30, 'quit', function()
            love.event.quit()
        end),
    }
end

function start:enter()

    lg.setBackgroundColor(Colors[2])

end

function start:resume()

    lg.setBackgroundColor(Colors[2])

end

function start:update(dt)
    for _, b in ipairs(self.buttons) do
        b:update(dt)
    end
end

function start:keypressed(key, code)

end

function start:mousepressed(x, y, mbutton)
    local mx, my = Resolution.toGame(x, y)
    for _, b in ipairs(self.buttons) do
        b:click(mx, my, mbutton)
    end
end

function start:draw()
    for _, b in ipairs(self.buttons) do
        b:render()
    end
end

return start
