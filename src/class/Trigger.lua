

Trigger = Class{}

function Trigger:init(text, x, y, h, world)

    self.x = x
    self.y = y
    self.h = h
    self.name = 'trigger'

    self.func   = nil
    self.active = false
    self.text_y = VIRT_HEIGHT
    self.text_h = 100
    self.t      = tostring(text)

    world:add(self, x, y, 1, h)
end

function Trigger:trigger(func)
    if not self.active then return
    elseif self.text_y == VIRT_HEIGHT then
        -- Make sure we can't spam it
        self.active = false

        -- Tween in
        Timer.tween(0.5, {
            [self] = { text_y = VIRT_HEIGHT - self.text_h}
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
        Timer.after(8, function()
            -- Tween out
            Timer.tween(0.5, {
                [self] = { text_y = VIRT_HEIGHT}
            }) : ease(Easing.inExpo)
        end)
    end
end

function Trigger:render()
    lg.setColor(Colors[4])
    lg.rectangle('fill', 0, self.text_y, VIRT_WIDTH, self.text_h)

    lg.setFont(Fonts.monospace[14])
    lg.setColor(Colors[7])
    lg.printf(self.t, 0, self.text_y + self.text_h / 2, VIRT_WIDTH, 'center')
end