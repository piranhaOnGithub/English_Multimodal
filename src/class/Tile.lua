

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
    lg.setColor(1, 1, 1, 1)
    lg.draw(Graphics['tileset'], Graphics.tile[self.t], self.x, self.y, 0, 3, 3)
    if DEBUG then
        lg.setColor(Colors[2])
        lg.rectangle('fill', self.x, self.y, TILE_SIZE, TILE_SIZE)
    end
end