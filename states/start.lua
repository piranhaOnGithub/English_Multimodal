local start = {}

function start:init()
    self.buttons = {
        Button(210, 130, 70, 20, 'game', function()
            State.switch(States.game)
        end),
    }
end

function start:enter()
    
    lg.setBackgroundColor(0.2, 0.22, 0.2)

end

function start:update(dt)

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
    lg.setFont(Fonts.default[30])
    lg.printf("Hello World!", 0, VIRT_HEIGHT / 2, VIRT_WIDTH, 'center')

    lg.setFont(Fonts.default[10])
    for _, b in ipairs(self.buttons) do
        b:render(Resolution.toGame(lm.getPosition()))
    end
end

return start
