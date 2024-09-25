local game = {}

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

    self.text = {
        [1] = Dialogue('I am number one!'),
        [2] = Dialogue('I am also definitely number one as well also')
    }

    self.camera = Camera.new(0, 0, 0.5)
end

function game:enter()

    local levelGen = require 'src.levelmaker'

    -- Create a fresh world
    self.world = Bump.newWorld(TILE_SIZE)
    self.map = {
        ['info'] = {}
    }

    levelGen(self)

    -- Player

    --[[ THE PLAYER KEEPS TELEPORTING BACK TO THE
            INITIAL SPAWN POSITION AFTER A DELAY ]]
    self.player = Player(100, 300, self.world)

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

    self.camera:lookAt(self.player.x, self.player.y)

    LastKeyPress = {}
end

function game:keypressed(key, code)
    if key == '1' then
        self.text[1]:trigger()
    elseif key == '2' then
        self.text[2]:trigger()
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
    end

    self.camera:detach()

    -- for _, b in ipairs(self.buttons) do
    --     b:render()
    -- end

    for _, d in ipairs(self.text) do
        d:render()
    end
end

return game
