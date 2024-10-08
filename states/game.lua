local game = {}

local function removeTiles(self, array)
    for i = 1, #self.map[array] do
        local item = self.map[array][i]
        self.world:remove(item)
    end
end

local function summonTiles(self, array)
    for i = 1, #self.map[array] do
        local item = self.map[array][i]
        self.world:add(item, item.x, item.y, TILE_SIZE, TILE_SIZE)
    end
end

function game:init()

    -- Intitiate buttons
    self.buttons = {
        Button(210, 130, 70, 20, 'Back', function()
            State.switch(States.start)
        end),
        Button(410, 130, 70, 20, 'Settings', function()
            State.push(States.config)
        end),
    }

    self.camera = Camera.new(0, 0, 1.5)
end

function game:enter()

    local levelGen = require 'src.levelmaker'

    -- Create a fresh world
    self.world = Bump.newWorld(TILE_SIZE)
    self.map = {
        ['info'] = {}
    }
    self.triggers = {
        [1] = Trigger('I am number one!', 33 * TILE_SIZE, 0, 6 * TILE_SIZE, self.world),
        [2] = Trigger('I am also definitely number one as well also', 10 * TILE_SIZE, 0, 6 * TILE_SIZE, self.world)
    }
    self.actions = {
        [1] = function()
            removeTiles(self, 2)
            summonTiles(self, 3)
            self.triggers[2].active = true
        end,
        [2] = function ()
            removeTiles(self, 3)
            summonTiles(self, 2)
        end
    }

    -- Add functions
    for i = 1, math.min(#self.triggers, #self.actions) do
        self.triggers[i].func = self.actions[i]
    end

    -- First trigger is active
    self.triggers[1].active = true

    levelGen(self)

    -- Player
    self.player = Player(0, 0, self.world)

    lg.setBackgroundColor(Colors[16])

end

function game:resume()
    lg.setBackgroundColor(Colors[16])
end

function game:update(dt)

    self.player:update(dt)

    Timer.update(dt)

    -- for _, b in ipairs(self.buttons) do
    --     b:update(dt)
    -- end

    self.camera:lookAt(self.player.x + self.player.w / 2, self.player.y + self.player.h / 2)

    LastKeyPress = {}
end

function game:keypressed(key, code)
    if key == 'kp1' then
        self.triggers[1]:trigger(function()
            removeTiles(self, 2)
            summonTiles(self, 3)
        end)
    elseif key == 'kp2' then
        self.triggers[2]:trigger(function()
            removeTiles(self, 3)
            summonTiles(self, 2)
        end)
    end
    if DEBUG then
        self.camera:zoomTo(0.25)
    else
        self.camera:zoomTo(1.5)
    end
end

function game:mousepressed(x, y, mbutton)

    -- local mx, my = Resolution.toGame(x, y)
    -- for _, b in ipairs(self.buttons) do
    --     b:click(mx, my, mbutton)
    -- end
end

function game:draw()

    self.camera:attach(0, 0, VIRT_WIDTH, VIRT_HEIGHT)

    local items, len = self.world:getItems()

    for i = 1, len do
        local item = items[i]
        if item.name == 'tile' then
            item:render(item)
        end
    end

    self.player:render()

    if DEBUG then
        lg.setColor(Colors[10])
        for i = 1, #self.map['info'] do
            local info = self.map['info'][i]
            lg.rectangle('line', info.x * TILE_SIZE, info.y * TILE_SIZE, info.w * TILE_SIZE, info.h * TILE_SIZE)
        end
        lg.setColor(Colors[9])
        for i = 1, #self.triggers do
            local hit = self.triggers[i]
            if hit.active then
                lg.line(hit.x, hit.y, hit.x, hit.y + hit.h)
            end
        end
    end

    self.camera:detach()

    -- for _, b in ipairs(self.buttons) do
    --     b:render()
    -- end

    for _, d in ipairs(self.triggers) do
        d:render()
    end
end

return game
