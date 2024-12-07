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
        if item.t > 0 and item.t <= 28 then -- normal
            self.world:add(item, item.x, item.y, TILE_SIZE, TILE_SIZE)
        elseif item.t == 29 then -- ladder
            self.world:add(item, item.x + TILE_SIZE / 5, item.y, TILE_SIZE / 2.5, TILE_SIZE)
        elseif item.t == 30 then -- fence left
            self.world:add(item, item.x + TILE_SIZE / 5, item.y - TILE_SIZE, TILE_SIZE / 5, TILE_SIZE * 2)
        elseif item.t == 31 then -- fence right
            self.world:add(item, item.x + TILE_SIZE - TILE_SIZE / 2.5, item.y - TILE_SIZE, TILE_SIZE / 5, TILE_SIZE * 2)
        end
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

    self.camera = Camera.new(0, 0, 1)
    self.canvas = lg.newCanvas(VIRT_WIDTH, VIRT_HEIGHT)
end

function game:enter()

    local levelGen = require 'src.levelmaker'

    -- Create a fresh world
    self.world = Bump.newWorld(TILE_SIZE)
    self.map = {
        ['info'] = {}
    }

    -- Add triggers
    self.triggers = {
        [1] = Trigger(nil, 40 * TILE_SIZE, 3 * TILE_SIZE, 3 * TILE_SIZE, self.world),
        [2] = Trigger(nil, 34 * TILE_SIZE, -2 * TILE_SIZE, TILE_SIZE * 3, self.world),
        [3] = Trigger(nil, 33 * TILE_SIZE, -2 * TILE_SIZE, TILE_SIZE * 3, self.world),
    }
    -- Add actions
    self.actions = {
        [1] = function()
            removeTiles(self, 2)
            summonTiles(self, 3)
            self.triggers[2].active = true
        end,
        [2] = function ()
            removeTiles(self, 7)
            summonTiles(self, 8)
            self.triggers[3].active = true
        end,
        [3] = function ()
            removeTiles(self, 5)
            summonTiles(self, 6)
            self.triggers[3].active = true
        end
    }
    -- Add actions to triggers
    for i = 1, math.min(#self.triggers, #self.actions) do
        self.triggers[i].func = self.actions[i]
    end

    -- First trigger is active
    self.triggers[1].active = true

    levelGen(self)

    -- Player
    self.player = Player(TILE_SIZE * 30, 0, self.world)

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

    self.camera:lookAt(self.player.x + self.player.w / 2, self.player.y - VIRT_HEIGHT / 20)

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
        self.camera:zoomTo(0.5)
    else
        self.camera:zoomTo(2)
    end
end

function game:mousepressed(x, y, mbutton)

    -- local mx, my = Resolution.toGame(x, y)
    -- for _, b in ipairs(self.buttons) do
    --     b:click(mx, my, mbutton)
    -- end
end

function game:draw()

    -- Camera is drawn to canvas, then scaled
    self.camera:attach(0, 0, VIRT_WIDTH, VIRT_HEIGHT)

    -- Begin canvas
    lg.setCanvas(self.canvas)

    -- Clear the canvas
    love.graphics.clear(0, 0, 0, 0)

    lg.setColor(1, 1, 1, 1)

    local items, len = self.world:getItems()

    for i = 1, len do
        local item = items[i]
        if item.name == 'tile' and item.x + TILE_SIZE >= self.player.x - VIRT_WIDTH / 2 and item.x <= self.player.x + self.player.w + VIRT_WIDTH / 2 then
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

    -- End canvas
    lg.setCanvas()

    self.camera:detach()

    -- for _, b in ipairs(self.buttons) do
    --     b:render()
    -- end

    -- Scaling starts here
    Resolution.start()

    lg.setColor(1, 1, 1, 1)
    lg.draw(self.canvas, 0, 0)

    for _, d in ipairs(self.triggers) do
        d:render()
    end

    Resolution.stop()
end

return game
