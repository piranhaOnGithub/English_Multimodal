local game = {}

function game:init()

    self.buttons = {
        Button(50, 100, 200, 10, 'Back', function()
            State.switch(States.start)
        end)
    }
end

function game:enter()

    lg.setBackgroundColor(0.2, 0.2, 0.22)

end

function game:update(dt)

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

    lg.setFont(Fonts.default[10])
    for _, b in ipairs(self.buttons) do
        b:render(Resolution.toGame(lm.getPosition()))
    end
end

return game
