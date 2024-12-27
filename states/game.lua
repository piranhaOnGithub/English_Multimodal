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

    self.camera = Camera.new(0, 0, 2)
    self.canvas = lg.newCanvas(VIRT_WIDTH, VIRT_HEIGHT)
    self.splash = Splash('potatato')
end

function game:enter()

    local levelGen = require 'src.levelmaker'

    -- Create a fresh world
    self.world = Bump.newWorld(TILE_SIZE)
    self.map = {['info'] = {}}
    levelGen(self)

    -- Add trigger locations
    self.triggers = {
        [1]     = Trigger(-6, -1, 1, TILE_SIZE * 3, self.world),
        [2]     = Trigger(5, 0, 1, TILE_SIZE * 3, self.world),
        [3]     = Trigger(11, -2, 1, TILE_SIZE * 3, self.world),
        [4]     = Trigger(26, -3, 1, TILE_SIZE * 3, self.world),
        [5]     = Trigger(40, 3, 1, TILE_SIZE * 3, self.world),
        [6]     = Trigger(33.5, 3, TILE_SIZE * 14.5, 1, self.world),
        [7]     = Trigger(36, -1, 1, TILE_SIZE * 3, self.world),
        [8]     = Trigger(23, -3, 1, TILE_SIZE * 3, self.world),
        [9]     = Trigger(32.5, -2, 1, TILE_SIZE * 3, self.world),
        [10]    = Trigger(48, -2, 1, TILE_SIZE * 4, self.world),
        [11]    = Trigger(56, -1, 1, TILE_SIZE * 3, self.world),
        [12]    = Trigger(48.5, -1, 1, TILE_SIZE * 3, self.world),
        -- [5]     = Trigger(70.5, 8.75, 1, self.world),
        -- [6]     = Trigger(70.5, 10, 1, self.world),
    }
    -- Add trigger actions
    self.actions = {
        -- Intro - Parkour
        [1] = function()
            self.splash:show('You have been here for as long as you can remember')
            self.triggers[2].active = true
        end,
        [2] = function()
            self.splash:show('This world...')
            self.triggers[3].active = true
        end,
        [3] = function()
            self.splash:show('...you still didn\'t really understand it')
            self.triggers[4].active = true
        end,
        [4] = function()
            self.splash:show('It challenged you at times')
            self.triggers[5].active = true
        end,
        [5] = function()
            -- Create ladder (parkour)
            removeTiles(self, 2)
            summonTiles(self, 3)
            -- Allow escape (parkour)
            removeTiles(self, 1)
            summonTiles(self, 8)
            self.splash:show('Maybe it wanted you to stay')
            self.triggers[6].active = true
            self.triggers[8].active = true
        end,
        [6] = function()
            self.splash:show('You could accept defeat and turn back...')
            self.triggers[7].active = true
        end,
        [7] = function()
            -- Create platform (parkour)
            -- removeTiles(self, 5)
            summonTiles(self, 6)
            self.triggers[10].active = true
        end,
        [8] = function()
            -- Disable backtracking
            removeTiles(self, 3)
            removeTiles(self, 4)
            summonTiles(self, 2)
            summonTiles(self, 9)
            self.splash:show('...sometimes it was easier just to give up and try something new')
            self.triggers[6].active = false
            self.triggers[9].active = true
        end,
        [9] = function()
            self.splash:show('No turning back')
        end,
        [10] = function()
            self.splash:show('...but you persevered')
            self.triggers[11].active = true
        end,
        [11] = function()
            -- Disable backtracking
            removeTiles(self, 4)
            removeTiles(self, 5)
            removeTiles(self, 6)
            summonTiles(self, 11)
            self.triggers[12].active = true
        end,
        [12] = function()
            self.splash:show('No turning back')
        end,
        
        -- [5] = function()
        --     -- Teleport player (ladder)
        --     self.player.y = self.player.y + TILE_SIZE
        --     self.triggers[6].active = true
        -- end,
        -- [6] = function()
        --     -- Reset teleport (ladder)
        --     self.triggers[5].active = true
        -- end,
    }
    -- Add actions to triggers
    for i = 1, math.min(#self.triggers, #self.actions) do
        self.triggers[i].func = self.actions[i]
    end

    -- First trigger is active
    -- self.triggers[1].active = true
    self.triggers[6].active = true
    self.triggers[7].active = true

    -- Player
    -- self.player = Player(TILE_SIZE * -8, TILE_SIZE, self.world)
    self.player = Player(TILE_SIZE * 25, -5, self.world)

    lg.setBackgroundColor(Colors[16])

    -- Fade in
    self.fade_in_opacity = 1
    Timer.after(0.5, function()
        Timer.tween(0.75, {
            [self] = {fade_in_opacity = 0}
        }) : ease(Easing.inOutSine)
    end)
end

function game:resume()
    lg.setBackgroundColor(Colors[16])
end

function game:update(dt)

    self.player:update(dt)

    self.splash:update(dt)

    Timer.update(dt)

    self.camera:lookAt(self.player.x + self.player.w / 2, self.player.y - VIRT_HEIGHT / 20)

    LastKeyPress = {}
end

function game:keypressed(key, code)
    if key == 'kp1' then
        self.triggers[6]:trigger()
    elseif key == 'kp2' then
        self.triggers[7]:trigger()
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
        for i = 1, #self.triggers do
            local hit = self.triggers[i]
            if hit.active then
                lg.setColor(Colors[13])
                lg.line(hit.x, hit.y, hit.x + hit.w, hit.y + hit.h)
            else
                lg.setColor(Colors[9])
                lg.line(hit.x, hit.y, hit.x + hit.w, hit.y + hit.h)
            end
        end
    end

    -- End canvas
    lg.setCanvas()
    self.camera:detach()

    -- Scaling starts here
    Resolution.start()

    lg.setColor(1, 1, 1, 1)
    lg.draw(self.canvas, 0, 0)

    self.splash:render()

    lg.setColor(Colors[4][1], Colors[4][2], Colors[4][3], self.fade_in_opacity)
    lg.rectangle('fill', 0, 0, VIRT_WIDTH, VIRT_HEIGHT)

    Resolution.stop()
end

return game
