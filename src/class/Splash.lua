-- Display splash text

Splash = Class{}

function Splash:init()
    self.t = ''
    self.text_h     = 100
    self.text_y     = 0
    self.lemon_t = ''
    self.lemon_y = VIRT_HEIGHT
    self.opacity    = 1
    self.offset_x   = 0
    self.offset_y   = 0
    self.font       = Fonts.display
end

function Splash:show(message, alt_text)
    -- Transition between texts

    -- Tween out
    Timer.tween(0.5, {
        [self] = {text_y = -self.text_h, opacity = 0}
    }) : ease(Easing.inExpo)

    Timer.after(0.6, function()

        -- Change the text
        if alt_text == true then
            self.font = Fonts.light
        else
            self.font = Fonts.display
        end
        self.t = tostring(message)
        print(self.t)

        -- Tween back in
        Timer.tween(0.5, {
            [self] = {text_y = 0, opacity = 1}
        }) : ease(Easing.outExpo)
    end)
end

function Splash:displayLemons(player, limes)
    if limes then
        self.lemon_t = 'YOU HAVE ' .. player.limes .. ' LIME'
        if player.limes > 1 then
            self.lemon_t = self.lemon_t .. 'S'
        end
        Timer.after(5, function()
            Timer.tween(0.5, {
                [self] = {
                    lemon_y = VIRT_HEIGHT
                }
            }) : ease(Easing.inSine)
        end)
    else
        self.lemon_t = 'YOU HAVE ' .. player.lemons .. ' LEMON'
        if player.lemons > 1 then
            self.lemon_t = self.lemon_t .. 'S'
        end
    end

    Timer.tween(2, {
        [self] = {
            lemon_y = VIRT_HEIGHT - 60
        }
    }) : ease(Easing.outElastic)
end

function Splash:hideLemons()
    Timer.tween(0.5, {
        [self] = {
            lemon_y = VIRT_HEIGHT
        }
    }) : ease(Easing.inSine)
end

function Splash:update(dt)
    -- Fancy text logic here
    self.offset_x = math.cos(lt.getTime() * 2) * 5
    self.offset_y = math.sin(lt.getTime() * 2) * 2
end

function Splash:render()
    -- Splash
    lg.setFont(self.font[24])
    lg.setColor(Colors[4][1], Colors[4][2], Colors[4][3], self.opacity)
    lg.printf(self.t, -2 + self.offset_x, math.floor(self.text_y + self.text_h / 2) + 2 + self.offset_y, VIRT_WIDTH - 2 + self.offset_x, 'center')
    lg.setColor(Colors[5][1], Colors[5][2], Colors[5][3], self.opacity)
    lg.printf(self.t, self.offset_x, math.floor(self.text_y + self.text_h / 2) + self.offset_y, VIRT_WIDTH + self.offset_x, 'center')

    -- Lemons
    lg.setFont(Fonts.display[20])
    lg.setColor(Colors[4])
    lg.printf(self.lemon_t, -2, self.lemon_y + 2, VIRT_WIDTH - 2, 'center')
    lg.setColor(Colors[5])
    lg.printf(self.lemon_t, 0, self.lemon_y, VIRT_WIDTH, 'center')
end