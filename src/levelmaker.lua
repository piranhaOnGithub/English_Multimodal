-- Generate various levels for the game


local raw_data = {
    [1] = {
        info    = {
            x = 1,
            y = 0,
            w = 20,
            h = 15,
        },
        level   = {
            {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 5, 0, 0, 0, 0, 0},
            {0, 0, 5, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 5, 0, 0, 0, 0, 0},
            {0, 0, 5, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0, 0, 5, 5, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0, 0, 5, 5, 0, 0, 0, 0, 0, 0, 5, 5, 0, 0},
            {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 5, 0, 0},
            {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
            {0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
            {1, 1, 1, 1, 4, 4, 4, 4, 4, 1, 1, 0, 0, 0, 1, 1, 1, 1, 1, 1},
            {4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 1, 1, 1, 1, 1, 4, 4, 4, 4, 4},
            {4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4},
            {4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4},
            {4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4}
        }
    }
}

local function levelmaker(self)

    for map = 1, #raw_data do

        local current_map = {}

        -- Decode the maps
        local level = raw_data[map].level
        local info  = raw_data[map].info

        for y = 1, #level do
            for x = 1, #level[y] do
                if level[y][x] == 1 then
                    table.insert(current_map, Tile(
                        (info.x + x - 1) * TILE_SIZE,
                        (info.y + y - 1) * TILE_SIZE,
                        self.world,
                        2))
                end
            end
        end
        self.map[map] = current_map
        self.map['info'][map] = info
    end
end

return levelmaker