local start = {}

function start:init()
    self.num = 1
    self.buttons = {
        Button(VIRT_WIDTH / 2 - 50, VIRT_HEIGHT / 2 - 15, 100, 30, 'game', function()
            self.can_click = false
            Timer.tween(0.5, {
                [self] = {
                    fade_in_opacity = 1
                }
            }) : ease(Easing.outQuint)
            : finish(function()
                State.switch(States.intro)
            end)
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

    lg.setBackgroundColor(Colors[3])

    self.can_click = true

    self.fade_in_opacity = 1
    Timer.tween(0.75, {
        [self] = {fade_in_opacity = 0}
    }) : ease(Easing.inOutSine)

end

function start:resume()

    lg.setBackgroundColor(Colors[3])

end

function start:update(dt)
    if self.can_click then
        for _, b in ipairs(self.buttons) do
            b:update(dt)
        end
    end

    Timer.update(dt)
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

    Resolution.start()

    for _, b in ipairs(self.buttons) do
        b:render()
    end

    lg.setColor(Colors[4][1], Colors[4][2], Colors[4][3], self.fade_in_opacity)
    lg.rectangle('fill', 0, 0, VIRT_WIDTH, VIRT_HEIGHT)

    Resolution.stop()
end

return start
