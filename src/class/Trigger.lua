

Trigger = Class{}

function Trigger:init(x, y, h, world, next)

    self.x = x * TILE_SIZE
    self.y = y * TILE_SIZE
    self.h = h
    self.name = 'trigger'

    self.func   = nil
    self.next   = nil
    self.active = false

    world:add(self, self.x, self.y, 1, self.h)
end

function Trigger:trigger(func)
    if not self.active then return end

    -- Make sure we can't spam it
    self.active = false

    -- Run function (if passed)
    local script = func
    if func == nil then
        script = self.func
    end

    local status, err = pcall(script)
    if not status then
        print(err)
    end
end