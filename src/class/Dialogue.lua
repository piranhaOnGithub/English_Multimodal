

Dialogue = Class{}

function Dialogue:init(text)
    self.y = VIRT_HEIGHT
    self.h = 100
    self.t = tostring(text)
end

function Dialogue:trigger()
    if self.y == VIRT_HEIGHT then
        Timer.tween(1, {
            [self] = { y = VIRT_HEIGHT - self.h}
        }) : ease(Easing.outExpo)
    elseif self.y == VIRT_HEIGHT - self.h then
        Timer.tween(1, {
            [self] = { y = VIRT_HEIGHT}
        }) : ease(Easing.inExpo)
    end
end

function Dialogue:render()
    lg.setColor(Colors[4])
    lg.rectangle('fill', 0, self.y, VIRT_WIDTH, self.h)

    lg.setFont(Fonts.monospace[14])
    lg.setColor(Colors[7])
    lg.printf(self.t, 0, self.y + self.h / 2, VIRT_WIDTH, 'center')
end