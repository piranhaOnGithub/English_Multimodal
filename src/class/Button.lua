-- Button.lua

Button = Class{}

function Button:init(x, y, w, h, t, func)
    self.x = x
    self.y = y
    self.w = w
    self.h = h
    self.t = t
    self.func = func
end

function Button:click(mx, my, mButton)
    -- Determine whether the mouse actually hit the Button
    if mButton == 1 and mx >= self.x and mx <= self.x + self.w and my >= self.y and my <= self.y + self.h then
        self.func()
    end
end

function Button:render(mx, my)
    -- hitbox, purple, transparent
    love.graphics.setColor(0.1, 0, 0.2, 0.5)
    love.graphics.rectangle("fill", self.x, self.y, self.w, self.h)

    -- text
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.printf(tostring(self.t), self.x, self.y + self.h / 4, self.w, "center")

    -- Show whether the mouse is over the Button
    if mx >= self.x and mx <= self.x + self.w and my >= self.y and my <= self.y + self.h then
        love.graphics.setColor(1, 0, 0, 1)
        love.graphics.rectangle("line", self.x, self.y, self.w, self.h)
    end
end