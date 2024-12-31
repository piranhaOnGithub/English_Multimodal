

Lemon = Class{}

function Lemon:init(x, y, world, splash)
    self.x      = x * TILE_SIZE + TILE_SIZE / 4
    self.y      = y * TILE_SIZE + TILE_SIZE / 4
    self.name   = 'lemon'
    self.world  = world
    self.rotation = 0
    self.scale    = 1
    self.offset_x = 0
    self.offset_y = 0
    self.unsync   = (x + y) * 0.5
    self.acquired = false

    self.world:add(self, self.x, self.y, TILE_SIZE / 2, TILE_SIZE / 2)
end

function Lemon:pickup()
    self.acquired = true
    Timer.tween(1.5, {
        [self] = {
            rotation    = 4 * math.pi,
            scale       = 0,
            x           = self.x + TILE_SIZE / 2,
            y           = self.y + TILE_SIZE / 2
        }
    }) : ease(Easing.inOutQuint)
    : finish(function()
        self.world:remove(self)
    end)
end

function Lemon:update(dt)
    -- self.rotation = math.pi + math.cos(lt.getTime() * dt)
    self.offset_x = math.cos((self.unsync + lt.getTime()) * 3) * 3
    self.offset_y = math.sin((self.unsync + lt.getTime()) * 3) * 3
end

function Lemon:render()
    if not DEBUG then
        lg.setColor(1, 1, 1, 1)
        lg.push()
            lg.translate(self.x - 5, self.y - 5)
            lg.rotate(self.rotation)
            lg.draw(Graphics['lemon'], self.offset_x, self.offset_y, 0, self.scale, self.scale)
        lg.pop()
    else
        lg.setColor(Colors[14])
        lg.rectangle('fill', self.x, self.y, TILE_SIZE / 2, TILE_SIZE / 2)
    end
end