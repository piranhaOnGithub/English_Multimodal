local intro = {}

function intro:init()
    self.text = {
        'Stanley,',
        'It\'s been so long,',
        'Wake up...',
        'Hello world, this is the last message',
    }
end

function intro:enter()

    self.count = 1
    self.transparency = 0
    self.destination = 1

    lg.setBackgroundColor(Colors[4])

    Timer.every(2, function()
        Timer.tween(1, {
            [self] = {
                transparency = self.destination
            }
        })
        :finish(function()
            self.destination = self.destination * -1
            if self.destination == 1 then
                self.count = self.count + 1
            end
        end)
        :ease(Easing.outCubic)
    end)
    :limit(#self.text * 2)
    :finish(function()
        Timer.after(1, function()
            State.switch(States.game)
        end)
    end)
end

function intro:update(dt)
    Timer.update(dt)
end

function intro:keypressed(key, code)
    Timer.clear()
    State.switch(States.game)
end

function intro:mousepressed(x, y, mbutton)

end

function intro:draw()
    lg.setFont(Fonts.monospace[20])
    lg.setColor(Colors[5][1], Colors[5][2], Colors[5][3], self.transparency)
    lg.printf(self.text[math.min(self.count, #self.text)], 0, VIRT_HEIGHT / 2, VIRT_WIDTH, 'center')
end

return intro
