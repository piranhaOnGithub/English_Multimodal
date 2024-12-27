-- Display splash text

Splash = Class{}

function Splash:init()
    self.t = ''
    self.text_h     = 100
    self.text_y     = 0
    self.opacity    = 1
    self.offset_x   = 0
    self.offset_y   = 0
end

function Splash:show(message)
    -- Transition between texts

    -- Tween out
    Timer.tween(0.5, {
        [self] = {text_y = -self.text_h, opacity = 0}
    }) : ease(Easing.inExpo)

    Timer.after(0.6, function()

        -- Change the text
        self.t = tostring(message)
        print(self.t)

        -- Tween back in
        Timer.tween(0.5, {
            [self] = {text_y = 0, opacity = 1}
        }) : ease(Easing.outExpo)
    end)
end

function Splash:update(dt)
    -- Fancy text logic here
    self.offset_x = math.cos(lt.getTime() * 2) * 5
    self.offset_y = math.sin(lt.getTime() * 2) * 2
end

function Splash:render()
    lg.setFont(Fonts.display[24])
    lg.setColor(Colors[4][1], Colors[4][2], Colors[4][3], self.opacity)
    lg.printf(self.t, -2 + self.offset_x, math.floor(self.text_y + self.text_h / 2) + 2 + self.offset_y, VIRT_WIDTH - 2 + self.offset_x, 'center')
    lg.setColor(Colors[5][1], Colors[5][2], Colors[5][3], self.opacity)
    lg.printf(self.t, self.offset_x, math.floor(self.text_y + self.text_h / 2) + self.offset_y, VIRT_WIDTH + self.offset_x, 'center')
end

--[[

        -- Tween in
        Timer.tween(0.5, {
            [self] = {text_y = 0}
        }) : ease(Easing.outExpo)

        -- Run function (if passed)
        local script = func
        if func == nil then
            script = self.func
        end

        local status, err = pcall(script)
        if not status then
            print(err)
        end

        -- Wait
        Timer.after(5, function()
            -- Tween out
            Timer.tween(0.5, {
                [self] = {text_y = -self.text_h}
            }) : ease(Easing.inExpo)
        end)

]]