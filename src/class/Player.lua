

Player = Class{}

function Player:init(x, y, world, splash)
    self.x      = x
    self.y      = y
    self.w      = 10
    self.h      = 15
    self.dx     = 0
    self.dy     = 0
    self.speed  = 90
    self.name   = 'player'
    self.world  = world
    self.splash = splash
    self.phase  = false
    self.jumped = false
    self.inPlay = true
    self.lemons = 0
    self.limes  = 0

    self.world:add(self, self.x, self.y, self.w, self.h)
end

function Player:update(dt)

    if DEBUG then
        self.speed = 280
    else
        self.speed = 90
    end

    self.dx = Lume.clamp(self.dx, -1, 1)


    if self.inPlay then
        if lk.isDown('left') and not lk.isDown('right') and not lk.isDown('d')
        or lk.isDown('a') and not lk.isDown('right') and not lk.isDown('d') then
            self.dx = self.dx - 0.3
        elseif lk.isDown('right') and not lk.isDown('left') and not lk.isDown('a')
        or lk.isDown('d') and not lk.isDown('left') and not lk.isDown('a') then
            self.dx = self.dx + 0.3
        end

        if LastKeyPress['up'] and self.dy == 0.25
        or LastKeyPress['w'] and self.dy == 0.25
        or LastKeyPress['space'] and self.dy == 0.25 then
            self.dy = -3
            Audio['jump']:stop()
            Audio['jump']:setPitch(math.random(9, 11) / 10)
            Audio['jump']:play()
        end
    end

    if self.dy > 3.5 then
        self.jumped = true
    end

    if self.dy == 0.25 and self.dx ~= 0 then
        if not Audio['walk']:isPlaying() then
            Audio['walk']:setPitch(math.random(9, 11) / 10)
        end
        Audio['walk']:play()
    end

    -- Apply velocity
    local len = 0
    local cols
    self.x, self.y, cols, len = self.world:move(
        self,
        self.x + self.dx * self.speed * dt,
        self.y + self.dy * self.speed * dt,
        function(self, other)
            if self.phase then return nil
            elseif other.name == 'tile' then
                if other.t <= 28 then return 'slide' end
                if other.t == 29 then return 'cross' end
                if other.t >= 30 then return 'slide' end
            elseif other.name == 'trigger' then return 'cross'
            elseif other.name == 'lemon' then return 'cross' end
        end
    )

    for i = 1, len do
        local col = cols[i].other
        if self.phase then
            -- Don't do anything
        elseif col.name == 'tile' then
            if col.t <= 28 then
                if col.x < self.x + self.w and col.x + TILE_SIZE > self.x then
                    self.dy = 0.1
                    if self.jumped then
                        Audio['fall']:stop()
                        Audio['fall']:setPitch(math.random(9, 11) / 10)
                        Audio['fall']:play()
                        self.jumped = false
                    end
                elseif col.y < self.y then
                    self.dx = 0
                end
            elseif col.t == 29 then
                if lk.isDown('up')
                or lk.isDown('w')
                or lk.isDown('space') then
                    self.dy = -0.8
                    self.dx = 0
                    self.x = Lume.lerp(self.x, -self.w / 2 + col.x + TILE_SIZE / 2, 0.03)
                end

                if self.dy ~= 0.25 then
                    if not Audio['ladder']:isPlaying() then
                        Audio['ladder']:setPitch(math.random(9, 11) / 10)
                    end
                    Audio['ladder']:play()
                end

                self.dy = Lume.clamp(self.dy, -0.8, 0.8)
            elseif col.t == 30 or col.t == 31 then
                self.dx = 0
            end
        elseif col.name == 'trigger' and col.active then
            col:trigger()
        elseif col.name == 'lemon' and not col.acquired then
            col:pickup()

            Audio['lemon'][math.random(1, 3)]:clone():play()

            if not col.is_lime then
                self.lemons = self.lemons + 1
                self.splash:displayLemons(self, false)
                print('LEMON acquired. You now have ' .. tostring(self.lemons) .. ' LEMONs')
            else
                self.limes = self.limes + 1
                self.splash:displayLemons(self, true)
                print('LIME acquired. You now have ' .. tostring(self.limes) .. ' LIMEs')
            end
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
    self.dy = math.min(self.dy + 0.15, 300)
end

function Player:render()


    if DEBUG then
        lg.setColor(Colors[9])
        lg.rectangle('line', self.x, self.y, self.w, self.h)
        lg.setFont(Fonts.monospace[50])
        lg.print(math.floor(self.x / TILE_SIZE) .. ', ' .. math.floor(self.y / TILE_SIZE), self.x, self.y - 50)
    else

        -- Player walk animation

        -- Body
        lg.setColor(Colors[4])
        lg.rectangle('fill', self.x + 2.5, self.y, 5, 8)

        -- Leg
        lg.push()
        -- lg.setColor(Colors[9])
        lg.translate(self.x + 3.5, self.y + 7)
        lg.rotate((math.cos(lt.getTime() * 8) * (self.dx * 0.8)) % (math.pi * 2))
        lg.rectangle('fill', -1.5, 0, 3, 8)
        lg.pop()

        -- Other leg
        lg.push()
        -- lg.setColor(Colors[10])
        lg.translate(self.x + 6.5, self.y + 7)
        lg.rotate((math.cos(lt.getTime() * 8) * (-self.dx * 0.8)) % (math.pi * 2))
        lg.rectangle('fill', -1.5, 0, 3, 8)
        lg.pop()

        -- Arm
        lg.push()
        -- lg.setColor(Colors[14])
        lg.translate(self.x + 3, self.y)
        lg.rotate(((math.cos(lt.getTime() * 8) * -self.dx) % (math.pi * 2)) + 0.1)
        lg.rectangle('fill', -1.5, 0, 3, 7)
        lg.pop()

        -- Other arm
        lg.push()
        -- lg.setColor(Colors[15])
        lg.translate(self.x + 7, self.y)
        lg.rotate(((math.cos(lt.getTime() * 8) * self.dx) % (math.pi * 2)) - 0.1)
        lg.rectangle('fill', -1.5, 0, 3, 7)
        lg.pop()

        -- Head
        lg.push()
        lg.translate(self.x + self.w / 2, self.y - 3)
        lg.circle('fill', 0, 0, 4)
        lg.pop()
    end
end