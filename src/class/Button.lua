-- Button.lua

Button = Class{}

function Button:init(x, y, w, h, t, func)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.t = t
    self.func = func

    self.over = false
end

function Button:click(mx, my, mButton)
    -- Determine whether the mouse actually hit the Button
    if mButton == 1 and mx >= self.x and mx <= self.x + self.w and my >= self.y and my <= self.y + self.h then
        Audio['click']:stop()
        Audio['click']:play()
        self.func()
    end
end

function Button:update(dt)
    local mx, my = Resolution.toGame(love.mouse.getPosition())
    if mx >= self.x and mx <= self.x + self.w and my >= self.y and my <= self.y + self.h then
        if not self.over then
            Audio['hover']:stop()
            Audio['hover']:play()
        end
        self.over = true
    else
        self.over = false
    end
end

function Button:render()
    -- hitbox, purple, transparent
    love.graphics.setColor(Colors[4])
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)

    -- text
    love.graphics.setFont(Fonts.default[15])
    love.graphics.setColor(Colors[7])
    love.graphics.printf(tostring(self.t), self.x, self.y + self.h / 4, self.w, "center")

    -- Show whether the mouse is over the Button
    if self.over then
        love.graphics.setColor(Colors[2])
        love.graphics.setLineWidth(2)
        love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
    end
end