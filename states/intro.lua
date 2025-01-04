local intro = {}

function intro:init()
    -- self.text = {
    --     'Welcome back, traveller...'
    -- }
end

function intro:enter()

    self.transparency = 0

    Timer.after(0.5, function()
        Timer.tween(1, {
            [self] = {
                transparency = 1
            }
        }) : ease(Easing.inOutCubic)
        : finish(function()
            Timer.after(2, function()
                Timer.tween(0.5, {
                    [self] = {
                        transparency = 0
                    }
                }) : ease(Easing.inOutCubic)
                : finish(function()
                    State.switch(States.game)
                end)
            end)
        end)

        Timer.after(0.5, function()
            Audio['click']:setPitch(0.1)
            Audio['click']:clone():play()
            Audio['click']:clone():play()
        end)
    end)

    -- self.count = 1
    -- self.transparency = 0
    -- self.destination = 1

    lg.setBackgroundColor(Colors[4])

    -- Timer.every(2.5, function()
    --     Timer.tween(1, {
    --         [self] = {
    --             transparency = self.destination
    --         }
    --     })
    --     :finish(function()
    --         self.destination = self.destination * -1
    --         if self.destination == 1 then
    --             self.count = self.count + 1
    --         end
    --     end)
    --     :ease(Easing.outCubic)
    -- end)
    -- :limit(#self.text * 2)
    -- :finish(function()
    --     Timer.after(1, function()
    --         State.switch(States.game)
    --     end)
    -- end)
end

function intro:update(dt)
    Timer.update(dt)
end

function intro:keypressed(key, code)
    if key == 'space' then
        Timer.clear()
        State.switch(States.game)
    end
end

function intro:mousepressed(x, y, mbutton)

end

function intro:draw()

    Resolution.start()

    lg.setFont(Fonts.display[48])
    lg.setColor(Colors[5][1], Colors[5][2], Colors[5][3], self.transparency)
    lg.printf('Welcome back, traveller...', 0, VIRT_HEIGHT / 2, VIRT_WIDTH, 'center')

    Resolution.stop()
end

return intro
