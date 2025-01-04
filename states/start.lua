local start = {}

function start:init()
    self.num = 1
    self.buttons = {
        Button(VIRT_WIDTH / 2 - 125, VIRT_HEIGHT / 2 + 130, 250, 35, 'CONTINUE', function()
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
        Button(VIRT_WIDTH / 2 - 125, VIRT_HEIGHT / 2 + 175, 65, 30, 'credits', function()
            State.push(States.credits)
        end),
        Button(VIRT_WIDTH / 2 - 50, VIRT_HEIGHT / 2 + 175, 100, 30, 'sound: on', function()
            if la.getVolume() == 1 then
                la.setVolume(0)
            else
                la.setVolume(1)
            end
        end),
        Button(VIRT_WIDTH / 2 + 60, VIRT_HEIGHT / 2 + 175, 65, 30, 'quit', function()
            love.event.quit()
        end),
    }
end

function start:enter()

    lg.setBackgroundColor(Colors[2])

    self.can_click = true

    self.fade_in_opacity = 1
    self.music_volume = 1

    Timer.tween(0.75, {
        [self] = {fade_in_opacity = 0}
    }) : ease(Easing.inOutSine)

    Audio['click']:setPitch(1)

    Audio['music-2']:play()
    Audio['music-2']:setLooping(true)


    self.star_x1 = 0
    self.star_x2 = -1200
end

function start:resume()

    lg.setBackgroundColor(Colors[2])

end

function start:update(dt)
    for _, b in ipairs(self.buttons) do
        if self.can_click then
            b:update(dt)
        end
    end

    Timer.update(dt)

    self.offset_x = math.cos(lt.getTime() * 2) * 5
    self.offset_y = math.sin(lt.getTime() * 2) * 2
    self.rotation = math.sin(lt.getTime() * -2) * 0.025

    self.star_x1 = self.star_x1 + 0.15
    self.star_x2 = self.star_x2 + 0.15

    if self.star_x1 >= VIRT_WIDTH then
        self.star_x1 = -1200
    end
    -- print(self.star_x1)

    if self.star_x2 >= VIRT_WIDTH then
        self.star_x2 = -1200
    end

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

    -- Stars
    lg.setColor(1, 1, 1, 1)
    lg.draw(Graphics['stars'], self.star_x1, -VIRT_WIDTH / 4, 0, 3, 3)
    lg.draw(Graphics['stars'], self.star_x2, -VIRT_WIDTH / 4, 0, 3, 3)

    for _, b in ipairs(self.buttons) do
        b:render()
    end

    -- Title
    lg.push()
    lg.translate(VIRT_WIDTH / 2, 240)
    lg.rotate(self.rotation)
    lg.setColor(0.9, 0.9, 0.9, 0.5)
    lg.draw(Graphics['title'], -270 + self.offset_x, -96 + self.offset_y, 0, 4, 4)
    lg.pop()

    lg.setColor(Colors[4][1], Colors[4][2], Colors[4][3], self.fade_in_opacity)
    lg.rectangle('fill', 0, 0, VIRT_WIDTH, VIRT_HEIGHT)

    Resolution.stop()
end

return start
