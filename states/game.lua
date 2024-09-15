local game = {}

function game:init()

    self.buttons = {
        Button(210, 130, 70, 20, 'Back', function()
            State.switch(States.start)
        end)
    }
end

function game:enter()

    lg.setBackgroundColor(Colors[4])

end

function game:update(dt)
    for _, b in ipairs(self.buttons) do
        b:update(dt)
    end
end

function game:keypressed(key, code)

end

function game:mousepressed(x, y, mbutton)

    local mx, my = Resolution.toGame(x, y)
    for _, b in ipairs(self.buttons) do
        b:click(mx, my, mbutton)
    end
end

function game:draw()
    for _, b in ipairs(self.buttons) do
        b:render()
    end
end

return game
