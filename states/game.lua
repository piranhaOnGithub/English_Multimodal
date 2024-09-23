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
end

function game:enter()

    local levelthemake = require 'src.levelmaker'

    -- Create a fresh world
    self.world = Bump.newWorld(TILE_SIZE)

    levelthemake(self.world)

    -- Tiles
    -- self.map = {
    --     Tile(100, 400, self.world, 'tile'),
    --     Tile(140, 360, self.world, 1)
    -- }

    self.text = {
        [1] = Dialogue('I am number one!'),
        [2] = Dialogue('I am also definitely number one as well also')
    }

    -- Player
    self.player = Player(100, 300, self.world)

    lg.setBackgroundColor(Colors[4])

end

function game:resume()
    lg.setBackgroundColor(Colors[4])
end

function game:update(dt)

    self.player:update(dt)

    Timer.update(dt)

    for _, b in ipairs(self.buttons) do
        b:update(dt)
    end

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

    local mx, my = Resolution.toGame(x, y)
    for _, b in ipairs(self.buttons) do
        b:click(mx, my, mbutton)
    end
end

function game:draw()

    local items, len = self.world:getItems()

    for i = 1, len do
        local item = items[i]
        if item.name == 'tile' then
            item:render(item)
        end
    end

    self.player:render()

    for _, b in ipairs(self.buttons) do
        b:render()
    end

    for _, d in ipairs(self.text) do
        d:render()
    end
end

return game
