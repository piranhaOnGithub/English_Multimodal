

Tile = Class{}

function Tile:init(x, y, world, t)
    self.x      = x
    self.y      = y
    self.t      = t
    self.world  = world

    self.world:add(self, self.x, self.y, 40, 40)
end

function Tile:render()
    lg.setColor(Colors[1])
    lg.rectangle('fill', self.x, self.y, 40, 40)
end