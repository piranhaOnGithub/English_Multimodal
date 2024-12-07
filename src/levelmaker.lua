-- Generate various levels for the game


local raw_data = {
    [1] = {
        info    = {
            x = 0,
            y = 0,
            w = 30,
            h = 5,
        },
        level   = {
            {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29, 9, 8, 8, 8, 10, 0, 0},
            {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29, 12, 0, 0, 0, 8, 8, 8},
            {30, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 29, 12, 0, 0, 0, 0, 0, 0},
            {2, 1, 1, 1, 1, 3, 0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 1, 1, 1, 1, 1, 1, 1, 3, 0, 0, 0, 0, 0, 0},
            {5, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0}
        }
    },
    [2] = {
        info    = {
            x = 30,
            y = 1,
            w = 3,
            h = 5,
        },
        level   = {
            {8, 8, 10},
            {0, 0, 13},
            {0, 0, 13},
            {0, 0, 13},
            {0, 0, 13},
            {0, 0, 2}
        }
    },
    [3] = {
        info    = {
            x = 30,
            y = 1,
            w = 3,
            h = 5,
            remove = true
        },
        level   = {
            {10, 29, 8},
            {13, 29, 0},
            {13, 29, 0},
            {13, 29, 0},
            {13, 29, 0},
            {2, 1, 1}
        }
    },
    [4] = {
        info    = {
            x = 33,
            y = 1,
            w = 9,
            h = 5
        },
        level   = {
            {0, 18, 0, 0, 0, 0, 0, 0, 18},
            {0, 21, 0, 18, 0, 0, 18, 0, 21},
            {0, 0, 0, 0, 0, 0, 21, 0, 0},
            {0, 0, 0, 0, 0, 0, 00, 0, 0},
            {0, 0, 0, 0, 0, 0, 0, 0, 0},
            {1, 1, 1, 1, 1, 1, 1, 1, 1}
    
        }
    },
    [5] = {
        info    = {
            x = 45,
            y = 0,
            w = 1,
            h = 2,
        },
        level   = {
            {18},
            {21}
        }
    },
    [6] = {
        info    = {
            x = 43,
            y = 1,
            w = 4,
            h = 1,
            remove = true
        },
        level   = {
            {16, 15, 15, 17}
        }
    },
    [7] = {
        info    = {
            x = 42,
            y = 4,
            w = 6,
            h = 4,
        },
        level   = {
            {0, 0, 0, 0, 0, 0, 12},
            {0, 0, 0, 0, 0, 0, 12},
            {1, 3, 0, 0, 0, 0, 12},
            {2, 1, 1, 1, 1, 1, 3}
        }
    },
    [8] = {
        info    = {
            x = 42,
            y = 4,
            w = 10,
            h = 4,
            remove = true
        },
        level   = {
            {0, 0, 0, 0, 0, 0, 12, 0, 0, 0, 0},
            {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
            {1, 3, 0, 0, 0, 0, 0, 0, 0, 0, 31},
            {2, 1, 1, 1, 1, 1, 1, 3, 0, 2, 1}
        }
    },
    [9] = {
        info    = {
            x = 48,
            y = 1,
            w = 12,
            h = 3,
        },
        level   = {
            {0, 0, 0, 0, 0, 0, 0, 0, 0, 2, 1, 1},
            {9, 10, 0, 0, 0, 0, 0, 2, 1, 1, 3, 0},
            {12, 2, 1, 1, 1, 1, 1, 1, 3, 0, 0, 0}
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
                if level[y][x] > 0 and level[y][x] <= 35 then
                    table.insert(current_map, Tile(
                        (info.x + x - 1) * TILE_SIZE,
                        (info.y + y - 1) * TILE_SIZE,
                        self.world,
                        level[y][x]))
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