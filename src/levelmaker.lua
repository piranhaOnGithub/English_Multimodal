-- Generate various levels for the game


local raw_data = {
    [1] = {
        info    = {
            x = 0,
            y = 0,
            w = 21,
            h = 4,
        },
        level   = {
            {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1},
            {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0},
            {1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0},
            {0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
        }
    },
    [2] = {
        info    = {
            x = 21,
            y = 0,
            w = 5,
            h = 4,
        },
        level   = {
            {1, 0, 0, 0, 0},
            {0, 1, 0, 0, 0},
            {0, 0, 1, 1, 0},
            {0, 0, 0, 0, 1}
        }
    },
    [3] = {
        info    = {
            x = 21,
            y = 0,
            w = 5,
            h = 8,
            remove = true
        },
        level   = {
            {1, 0, 0, 0, 0},
            {0, 1, 0, 0, 0},
            {0, 1, 0, 0, 0},
            {1, 0, 0, 0, 0},
            {1, 0, 0, 0, 0},
            {1, 0, 0, 0, 1},
            {0, 1, 0, 0, 0},
            {0, 0, 1, 1, 1}
        }
    },
    [4] = {
        info    = {
            x = 26,
            y = -2,
            w = 16,
            h = 12,
        },
        level   = {
            {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 0, 1, 1, 1},
            {0, 0, 1, 1, 1, 0, 0, 0, 1, 1, 1, 1, 0, 1, 0, 0},
            {1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 0, 0, 1, 0},
            {1, 0, 0, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0},
            {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 0},
            {0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0},
            {1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0},
            {0, 1, 1, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0}
        }
    },
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

        -- Some levels are spawned in later
        if info.remove then
            for i = 1, #current_map do
                self.world:remove(current_map[i])
            end
        end
        self.map[map] = current_map
        self.map['info'][map] = info
    end
end

return levelmaker