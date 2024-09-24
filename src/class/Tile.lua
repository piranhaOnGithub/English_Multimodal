

Tile = Class{}

function Tile:init(x, y, world, t)
    self.x      = x
    self.y      = y
    self.t      = t
    self.name   = 'tile'
    self.world  = world

    self.world:add(self, self.x, self.y, TILE_SIZE, TILE_SIZE)
end

function Tile:render()
    lg.setColor(Colors[13])
    lg.rectangle('fill', self.x, self.y, TILE_SIZE, TILE_SIZE)
end