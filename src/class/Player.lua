

Player = Class{}

function Player:init(x, y, world)
    self.x      = x
    self.y      = y
    self.w      = 20
    self.h      = 30
    self.dx     = 0
    self.dy     = 0
    self.speed  = 190
    self.name   = 'player'
    self.world  = world

    self.world:add(self, self.x, self.y, self.w, self.h)
end

function Player:update(dt)
    self.dx = Lume.clamp(self.dx, -1, 1)

    if lk.isDown('left') and not lk.isDown('right') then
        self.dx = self.dx - 0.3
    elseif lk.isDown('right') and not lk.isDown('left') then
        self.dx = self.dx + 0.3
    end

    if LastKeyPress['up'] and self.dy == 0.2 then
        self.dy = -3
    end

    -- Apply velocity
    local len = 0
    local cols
    self.x, self.y, cols, len = self.world:move(
        self,
        self.x + self.dx * self.speed * dt,
        self.y + self.dy * self.speed * dt,
        function(self, other)
            if other.name == 'tile' then return 'slide' end
            if other.name == 'trigger' then return 'cross' end
        end
    )

    for i = 1, len do
        local col = cols[i].other
        if col.name == 'tile' and col.x < self.x + self.w and col.x + TILE_SIZE > self.x then
            self.dy = 0.1
        elseif col.name == 'trigger' and col.active then
            col:trigger(nil)
        end
    end

    -- Apply friction
    if self.dx < -0.1 then
        self.dx = self.dx + 0.1
    elseif self.dx > 0.1 then
        self.dx = self.dx - 0.1
    else
        self.dx = 0
    end

    -- Apply gravity
    self.dy = math.min(self.dy + 0.1, 300)
end

function Player:render()
    lg.setColor(Colors[8])
    lg.rectangle('line', self.x, self.y, self.w, self.h)
end