

Tile = Class{}

function Tile:init(x, y, world, t)
    self.x      = x
    self.y      = y
    self.t      = t
    self.name   = 'tile'
    self.world  = world

    -- Set a custom hitbox for special tiles
    if self.t > 0 and self.t <= 28 then
        self.world:add(self, self.x, self.y, TILE_SIZE, TILE_SIZE)
    elseif self.t == 29 then
        self.world:add(self, self.x + TILE_SIZE / 5, self.y, TILE_SIZE / 2.5, TILE_SIZE)
    end
end

function Tile:render()
    lg.setColor(1, 1, 1, 1)
    lg.draw(Graphics['tileset'], Graphics.tile[self.t], self.x, self.y, 0, 3, 3)
    if DEBUG then
        lg.setColor(Colors[2])
        lg.rectangle('fill', self.x, self.y, TILE_SIZE, TILE_SIZE)
    end
end