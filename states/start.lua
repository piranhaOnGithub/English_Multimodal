local start = {}

function start:init()
    self.num = 1
    self.buttons = {
        Button(VIRT_WIDTH / 2 - 50, VIRT_HEIGHT / 2 + 30, 100, 30, 'game', function()
            self.can_click = false
            Timer.tween(0.5, {
                [self] = {
                    fade_in_opacity = 1,
                    music_volume = 0
                }
            }) : ease(Easing.outQuint)
            : finish(function()
                Audio['music-2']:stop()
                State.switch(States.intro)
            end)
        end),
        Button(VIRT_WIDTH / 2 - 50, VIRT_HEIGHT / 2 + 75, 100, 30, 'credits', function()
            State.push(States.credits)
        end),
        Button(VIRT_WIDTH / 2 - 50, VIRT_HEIGHT / 2 + 120, 100, 30, 'sound: on', function()
            if la.getVolume() == 1 then
                la.setVolume(0)
            else
                la.setVolume(1)
            end
        end),
        Button(VIRT_WIDTH / 2 - 50, VIRT_HEIGHT / 2 + 210, 100, 30, 'quit', function()
            love.event.quit()
        end),
    }
end

function start:enter()

    lg.setBackgroundColor(Colors[3])

    self.can_click = true

    self.fade_in_opacity = 1
    self.music_volume = 1

    Timer.tween(0.75, {
        [self] = {fade_in_opacity = 0}
    }) : ease(Easing.inOutSine)


    Audio['music-2']:play()
    Audio['music-2']:setLooping(true)

end

function start:resume()

    lg.setBackgroundColor(Colors[3])

end

function start:update(dt)
    for _, b in ipairs(self.buttons) do
        if self.can_click then
            b:update(dt)
        end
    end

    Timer.update(dt)

    Audio['music-2']:setVolume(self.music_volume)
end

function start:keypressed(key, code)

end

function start:mousepressed(x, y, mbutton)
    local mx, my = Resolution.toGame(x, y)
    if self.can_click then
        for k, b in ipairs(self.buttons) do
            b:click(mx, my, mbutton)
            if k == 3 then
                if la.getVolume() == 1 then
                    b.t = 'sound: on'
                else
                    b.t = 'sound: off'
                end
            end
        end
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
