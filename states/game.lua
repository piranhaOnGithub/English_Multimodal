local game = {}

local function removeTiles(self, array)
    -- Crashes when no tiles to remove
    local status, err = pcall(function()
        for i = 1, #self.map[array] do
            local item = self.map[array][i]
            self.world:remove(item)
        end
        print('---removed map section "' .. tostring(array) .. '"')
    end)

    if not status then
        print('---tried to remove map section "' .. tostring(array) .. '" but it didn\'t exist!')
    end
end

local function summonTiles(self, array)
    local status, err = pcall(function()
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
        print('----placed map section "' .. tostring(array) .. '"')
    end)

    if not status then
        print('----tried to place map section "' .. tostring(array) .. '" but it already existed!')
    end
end

local attributes = {
    'Wisdom',
    'Respect',
    'Happiness',
    'Integrity',
    'Trust',
    'Courage',
    'Loyalty',
    'Patience',
    'Peace',
}

local rhetoric = {
    'Could you really obtain',
    'all of that by',
    'climbing a ladder?',
}

local lemon_dialogue = {
    'Well, what have we here?',
    'A traveller seeking wisdom, perhaps?',
    'I\'m afraid this world may be the wrong place to find it...',
    '. . .',
    'Fetch me three lemons and I\'ll help you find what you seek...',
    'You know, kid, when life gives you lemons...\nyou make lemonade',
    'But going out and grabbing those lemons\ndoesn\'t make life any sweeter',
    'There\'s a lesson in that, kid',
    '- Lemonade Stand Man',
    '(P.S.) also... I accidentally dropped my\nwand and summoned an anvil...',
    'Let me know if you find it, okay?',
    '',
    'Ah! It seems you\'ve got everything figured out!',
    '. . .',
    'Erm... these are limes',
    'How did you think these were lemons?\nThey\'re literally green!',
    '. . .',
    'Well, it may not be the answer you\'re looking for,\nbut an artifact lies to the right that may help you...',
    '',
    'I suppose a path lies to your right that may help you...'
}

local function ladderTimer(self)
    if not self.triggers[20].active then return end
    local timeSpentOnLadder = lt.getTime() - self.ladderTimeStart
    local alt_text = false
    if self.currentSplash >= 6 and self.currentSplash <= 14 and self.shuffled then
        alt_text = true
    end

    local text = {
        'As you climb, you',
        'begin to wonder what',
        'may lie at the top',

        'The world had promised',
        'you what awaits your',
        'arrival at the summit...',

        '',
        attributes[1],
        '',

        '',
        attributes[2],
        '',

        '',
        attributes[3],
        '',

        '',
        'And you wondered...',
        '',

        rhetoric[1],
        rhetoric[2],
        rhetoric[3],

        '',
        'And the world kept',
        'whispering to you...',
    }

    -- Concatenate message and align to
    -- either right or left side of ladder
    local leftMargin = ''
    local rightMargin = ''
    if self.currentSplash % 2 == 1 then
        rightMargin = '\t\t\t\t\t\t\t\t\t'
    else
        leftMargin = '\t\t\t\t\t\t\t\t\t'
    end
    local message = leftMargin .. text[self.currentSplash % #text + 1] ..rightMargin .. '\n' ..
    leftMargin .. text[(self.currentSplash + 1) % #text + 1] .. rightMargin .. '\n' ..
    leftMargin .. text[(self.currentSplash + 2) % #text + 1] .. rightMargin

    -- Next splash shown every few seconds
    if math.floor(timeSpentOnLadder) >= self.splashTime then

        self.splash:show(message, alt_text)
        self.splashTime = self.splashTime + 5

        if self.currentSplash == 21 then
            -- New attributes
            attributes = Lume.shuffle(attributes)
            -- Don't replay the intro
            self.currentSplash = 6
            -- Remove redundant rhetorics
            rhetoric = {
                '',
                '',
                '',
            }
            self.shuffled = true
        else
            -- Next splash
            self.currentSplash = self.currentSplash + 3
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
    self.camera.smoother = Camera.smooth.damped(15)
    self.canvas = lg.newCanvas(VIRT_WIDTH, VIRT_HEIGHT)
    self.splash = Splash()

    -- Shuffle ladder attribute text
    attributes = Lume.shuffle(attributes)
end

function game:enter()

    local levelGen = require 'src.levelmaker'

    -- Create a fresh world
    self.world = Bump.newWorld(TILE_SIZE)
    self.map = {['info'] = {}}
    levelGen(self)

    -- Add trigger locations
    self.triggers = {
        -- Intro - Parkour
        [1]     = Trigger(-6, -1, 1, TILE_SIZE * 3, self.world),
        [2]     = Trigger(5, 0, 1, TILE_SIZE * 3, self.world),
        [3]     = Trigger(11, -2, 1, TILE_SIZE * 3, self.world),
        [4]     = Trigger(26, -3, 1, TILE_SIZE * 3, self.world),
        [5]     = Trigger(40, 3, 1, TILE_SIZE * 3, self.world),
        [6]     = Trigger(33.5, 2.5, TILE_SIZE * 14.5, 1, self.world),
        [7]     = Trigger(36, -1, 1, TILE_SIZE * 3, self.world),
        [8]     = Trigger(23, -3, 1, TILE_SIZE * 3, self.world),
        [9]     = Trigger(32.5, -2, 1, TILE_SIZE * 3, self.world),
        [10]    = Trigger(48, -2, 1, TILE_SIZE * 4, self.world),
        [11]    = Trigger(56, -1, 1, TILE_SIZE * 3, self.world),
        [12]    = Trigger(48.5, -1, 1, TILE_SIZE * 3, self.world),
        -- Ladder
        [13]    = Trigger(28, -3, 1, TILE_SIZE * 3, self.world),
        [14]    = Trigger(7, 4, 1, TILE_SIZE * 3, self.world),
        [15]    = Trigger(17, 4, 1, TILE_SIZE * 3, self.world),
        [16]    = Trigger(28, 4, 1, TILE_SIZE * 3, self.world),
        [17]    = Trigger(40.5, -0.5, 1, 1, self.world),
        [18]    = Trigger(40.5, -1.5, 1, 1, self.world),
        [19]    = Trigger(40.5, -0.5, 1, 1, self.world),
        [20]    = Trigger(38, 3, TILE_SIZE * 5, 1, self.world),
        [21]    = Trigger(40.5, -7, 1, 1, self.world),
        [22]    = Trigger(36, -5, TILE_SIZE * 9, 1, self.world),
        [23]    = Trigger(33, 5, 1, TILE_SIZE * 3, self.world),
        [24]    = Trigger(48, 5, 1, TILE_SIZE * 3, self.world),
        [25]    = Trigger(61, 4, 1, TILE_SIZE * 3, self.world),
        [26]    = Trigger(77, 4, 1, TILE_SIZE * 3, self.world),
        [27]    = Trigger(94.5, 1, 1, TILE_SIZE * 3, self.world),
        [28]    = Trigger(96.5, 1, 1, TILE_SIZE * 6, self.world),
        -- Ladder when no climb
        [29]    = Trigger(48, 5, 1, TILE_SIZE * 3, self.world),
        [30]    = Trigger(59, 7, 1, TILE_SIZE * 3, self.world),
        -- Ladder to lemonade man
        [31]    = Trigger(104, 4, 1, TILE_SIZE * 3, self.world),
        -- Lemonade man
        [32]    = Trigger(67, -2, 1, TILE_SIZE * 3, self.world),
        [33]    = Trigger(58, -3, 1, TILE_SIZE * 3, self.world),
        [34]    = Trigger(41.5, -2, 1, TILE_SIZE * 3, self.world),
        [35]    = Trigger(49, -1, 1, TILE_SIZE * 3, self.world),
        [36]    = Trigger(55, -3, 1, TILE_SIZE * 3, self.world),
        [37]    = Trigger(55, -3, 1, TILE_SIZE * 3, self.world),
        [38]    = Trigger(55, -3, 1, TILE_SIZE * 3, self.world),
        -- Lemonade man to ladder
        [39]    = Trigger(37, 7, 1, TILE_SIZE * 3, self.world),
        [40]    = Trigger(20, 3, 1, TILE_SIZE * 3, self.world),
        [41]    = Trigger(65.5, -4, 1, TILE_SIZE * 3, self.world),
        [42]    = Trigger(80.5, -11, 1, TILE_SIZE * 3, self.world),
        [43]    = Trigger(6.5, 2, 1, TILE_SIZE * 3, self.world),
        -- Lemonade crush to end
        [44]    = Trigger(101, -9, 1, TILE_SIZE * 3, self.world),
        [45]    = Trigger(88, -6, 1, TILE_SIZE * 4, self.world),
        -- Ladder to end
        [46]    = Trigger(63, 4, 1, TILE_SIZE * 3, self.world),
        [47]    = Trigger(75, 4, 1, TILE_SIZE * 3, self.world),
        [48]    = Trigger(84, 4, 1, TILE_SIZE * 3, self.world),
        [49]    = Trigger(59, -3, 1, TILE_SIZE * 3, self.world),
        [50]    = Trigger(68, -10, 1, TILE_SIZE * 3, self.world),
        [51]    = Trigger(75, -11, 1, TILE_SIZE * 3, self.world),
        [52]    = Trigger(17, 4, 1, TILE_SIZE * 3, self.world),
        -- End
        [53]    = Trigger(80, 25, TILE_SIZE, 1, self.world),
        [54]    = Trigger(73, 40, 1, TILE_SIZE * 3, self.world),
        [55]    = Trigger(88, 40, 1, TILE_SIZE * 3, self.world),
        [56]    = Trigger(80, 40, TILE_SIZE, 1, self.world),
        [57]    = Trigger(79.5, 28, 1, TILE_SIZE * 3, self.world),
        [58]    = Trigger(65, 31.5, TILE_SIZE * 14, 1, self.world),
        [59]    = Trigger(80.5, -11, 1, TILE_SIZE * 3, self.world),
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
            self.splash:show('It challenged you at times...')
            self.triggers[5].active = true
        end,
        [5] = function()
            -- Create ladder (parkour)
            removeTiles(self, 2)
            summonTiles(self, 3)
            -- Allow escape (parkour)
            removeTiles(self, 1)
            summonTiles(self, 8)
            self.splash:show('...presenting you with impossible obstacles')
            self.triggers[6].active = true
            self.triggers[8].active = true
        end,
        [6] = function()
            self.splash:show('Turning around often seemed like the only option...')
            self.triggers[7].active = true
        end,
        [7] = function()
            -- Create platform and route to lemonade man
            summonTiles(self, 6)
            summonTiles(self, 18)
            self.triggers[10].active = true
        end,
        [8] = function()
            -- Disable backtracking
            self.skippedParkour = true
            removeTiles(self, 3)
            removeTiles(self, 4)
            removeTiles(self, 5)
            removeTiles(self, 6)
            removeTiles(self, 7)
            removeTiles(self, 18)
            summonTiles(self, 2)
            summonTiles(self, 9)
            summonTiles(self, 11)
            self.splash:show('...giving up felt bitter')
            self.triggers[5].active = false
            self.triggers[6].active = false
            self.triggers[7].active = false
            self.triggers[10].active = false
            self.triggers[9].active = true
            self.triggers[14].active = true
        end,
        [9] = function()
            self.splash:show('NO TURNING BACK')
            self.triggers[13].active = true
        end,
        [10] = function()
            self.splash:show('...but your determination prevailed')
            self.triggers[11].active = true
        end,
        [11] = function()
            -- Disable backtracking
            removeTiles(self, 3)
            removeTiles(self, 4)
            removeTiles(self, 5)
            removeTiles(self, 6)
            summonTiles(self, 10)
            self.triggers[8].active = false
            self.triggers[12].active = true
            self.triggers[32].active = true
        end,
        [12] = function()
            self.splash:show('NO TURNING BACK')
        end,
        -- Ladder
        [13] = function()
            self.splash:show('...giving up felt bitter')
        end,
        [14] = function()
            -- Open route to ladder
            removeTiles(self, 8)
            removeTiles(self, 2)
            removeTiles(self, 9)
            summonTiles(self, 12)
            summonTiles(self, 13)
            summonTiles(self, 16)
            summonTiles(self, 27)
            if not self.has_lemoned then
                summonTiles(self, 17)
            else
                summonTiles(self, 31)
                summonTiles(self, 35)
                summonTiles(self, 37)
            end
            self.splash:show('The world gave you a choice')
            self.triggers[9].active = false
            self.triggers[15].active = true
        end,
        [15] = function()
            self.camera.smoother = Camera.smooth.damped(22)
            self.triggers[16].active = true
            self.splash:show('A relic that could potentially help you... or not')
        end,
        [16] = function()
            self.has_laddered = true
            self.camera.smoother = Camera.smooth.damped(30)
            self.triggers[17].active = true
            self.triggers[29].active = true
            self.splash:show('The LADDER OF \'SUCCESS\' awaits its next climber')
        end,
        [17] = function()
            self.triggers[18].active = true
            self.triggers[20].active = true
            self.ladderTimeStart = lt.getTime()
            self.camera.smoother = Camera.smooth.none()
        end,
        [18] = function()
            self.triggers[19].active = true
            self.player.y = self.player.y + TILE_SIZE
        end,
        [19] = function()
            self.triggers[18].active = true
        end,
        [20] = function()
            self.ladderTimeEnd = lt.getTime()
            self.camera.smoother = Camera.smooth.damped(15)
            removeTiles(self, 16)
            removeTiles(self, 17)
            removeTiles(self, 31)
            removeTiles(self, 35)
            summonTiles(self, 14)
            summonTiles(self, 15)
            self.triggers[17].active = false
            self.triggers[18].active = false
            self.triggers[29].active = false
            self.triggers[30].active = false
            self.triggers[21].active = true
            self.triggers[23].active = true
            self.triggers[24].active = true
            self.splash:show('')
        end,
        [21] = function()
            self.splash:show('...nothing but broken dreams...')
            self.triggers[22].active = true
        end,
        [22] = function()
            self.splash:show('')
        end,
        [23] = function()
            removeTiles(self, 13)
        end,
        [24] = function()
            self.triggers[23].active = false
            removeTiles(self, 13)
            self.triggers[25].active = true
            self.splash:show('You begin to think about all the time you wasted,\ntrying to climb that cursed ladder...')
        end,
        [25] = function()
            local time = math.floor(self.ladderTimeEnd - self.ladderTimeStart)
            local minutes = math.floor(time / 60)
            local seconds = time - minutes * 60
            if minutes > 1 then
                -- Can't be saying "1 minutes" now can we...
                self.humanTime = tostring(minutes .. ' minutes and ' .. seconds .. ' seconds')
            elseif minutes > 0 then
                -- Saying "0 minutes" is even worse...
                self.humanTime = tostring(minutes .. ' minute and ' .. seconds .. ' seconds')
            else
                -- We don't care about saying "1 seconds"
                self.humanTime = tostring(seconds .. ' seconds')
            end
            self.triggers[26].active = true
            self.splash:show('...it must have been about ' .. self.humanTime .. '!')
        end,
        [26] = function()
            self.triggers[27].active = true
            self.triggers[28].active = true
            self.splash:show('You resolve to stay away from random ladders')
        end,
        [27] = function()
            self.splash:show('wow...')
        end,
        [28] = function()
            removeTiles(self, 14)
            if not self.has_lemoned then
                self.camera.smoother = Camera.smooth.none()
                self.triggers[31].active = true
                summonTiles(self, 22)
            else
                summonTiles(self, 31)
                summonTiles(self, 32)
                summonTiles(self, 37)
                self.triggers[48].active = true
            end
        end,
        -- Ladder when no climb
        [29] = function()
            if not self.has_lemoned then
                self.triggers[30].active = true
                self.camera.smoother = Camera.smooth.none()
            else
                self.triggers[46].active = true
            end
            self.skippedLadder = true
            removeTiles(self, 13)
            self.triggers[17].active = false
            self.triggers[18].active = false
            self.splash:show('...another opportunity too good to be true')
        end,
        [30] = function()
            -- Create a new player because collisions are
            -- broken and so is my mind
            self.player = Player(self.player.x + TILE_SIZE * 8, TILE_SIZE - self.player.h, self.world, self.splash)

            self.background_x = self.background_x - TILE_SIZE * 4.6
            self.background_y = self.background_y + TILE_SIZE * 1

            self.stand_opacity = 1
            removeTiles(self, 11)
            removeTiles(self, 12)
            removeTiles(self, 13)
            removeTiles(self, 16)
            removeTiles(self, 17)
            removeTiles(self, 27)
            summonTiles(self, 18)
            summonTiles(self, 19)
            self.triggers[33].active = true
            self.splash:show('You needed to find a way out of here')
        end,
        [31] = function()
            -- Create a new player because collisions are
            -- broken and so is my mind
            self.camera.smoother = Camera.smooth.none()
            self.player = Player(self.player.x - TILE_SIZE * 37, TILE_SIZE - self.player.h, self.world, self.splash)

            self.background_x = self.background_x + TILE_SIZE * 2.5
            self.background_y = self.background_y - TILE_SIZE * 6

            self.stand_opacity = 1
            removeTiles(self, 11)
            removeTiles(self, 12)
            removeTiles(self, 13)
            removeTiles(self, 14)
            removeTiles(self, 15)
            removeTiles(self, 27)
            summonTiles(self, 18)
            summonTiles(self, 19)
            self.triggers[33].active = true
            self.splash:show('You needed to find a way out of here')
        end,
        -- Lemonade man
        [32] = function()
            self.stand_opacity = 1
            self.triggers[12].active = false
            self.triggers[33].active = true
            removeTiles(self, 7)
            removeTiles(self, 8)
            removeTiles(self, 10)
            summonTiles(self, 19)
            self.splash:show('If only you could find a way out of here')
        end,
        [33] = function()

            -- Actual
            Lemon(37, 3, self.world)
            Lemon(36, -2, self.world)
            Lemon(27, 0, self.world)

            -- Decoy
            Lemon(21, -2, self.world)

            -- Top floor
            Lemon(11, -8, self.world)
            Lemon(12, -8, self.world)
            Lemon(13, -8, self.world)
            Lemon(14, -8, self.world)
            Lemon(16, -8, self.world)

            -- Bottom floor
            Lemon(10, -5, self.world)
            Lemon(11, -5, self.world)
            Lemon(12, -5, self.world)
            Lemon(14, -5, self.world)
            Lemon(16, -5, self.world)
            Lemon(17, -5, self.world)

            self.lemon_camera = true
            self.has_lemoned = true
            self.currentSplash = 1
            self.camera.smoother = Camera.smooth.damped(2)

            Timer.every(4, function()
                self.currentSplash = self.currentSplash + 1
                self.splash:show(lemon_dialogue[self.currentSplash], true)
            end) : limit(4)

            Timer.after(20, function()
                self.lemon_camera = false
                self.camera.smoother = Camera.smooth.damped(15)
                removeTiles(self, 20)
                removeTiles(self, 21)
            end)

            self.triggers[34].active = true
            summonTiles(self, 20)
            summonTiles(self, 21)
            summonTiles(self, 23)
            summonTiles(self, 24)
            self.splash:show(lemon_dialogue[1], true)
            self.lemonadeMan = LemonadeMan(58 * TILE_SIZE, -0.5 * TILE_SIZE, self.player)
            self.lemonadeMan.opacity = 0
            Timer.tween(2, {
                [self.lemonadeMan] = {
                    opacity = 1
                }
            }) : ease(Easing.inOutQuad)
        end,
        [34] = function()
            self.triggers[35].active = true
        end,
        [35] = function()
            if self.player.lemons == 3 then
                self.triggers[36].active = true
            elseif self.player.lemons < 3 then
                self.triggers[37].active = true
            else
                self.stand_opacity = 0
                self.sign_opacity = 1
                self.lemonadeMan.opacity = 0
                self.triggers[38].active = true
            end

            local items, len = self.world:getItems()

            for i = 1, len do
                local item = items[i]
                if item.name == 'lemon' then
                    self.world:remove(item)
                end
            end

            self.has_lemoned = true
            removeTiles(self, 23)
            summonTiles(self, 36)
        end,
        [36] = function()
            -- Correct amount of lemons
            self.lemon_camera = true
            self.camera.smoother = Camera.smooth.damped(2)
            self.currentSplash = 13
            summonTiles(self, 20)
            summonTiles(self, 21)
            self.splash:show(lemon_dialogue[self.currentSplash], true)
            self.splash:hideLemons()

            Timer.every(4, function()
                self.currentSplash = self.currentSplash + 1
                self.splash:show(lemon_dialogue[self.currentSplash], true)

                if self.currentSplash == 16 then
                    self.temporary_lemon = Lemon(57, -3, self.world)
                    self.temporary_lemon.opacity = 0
                    Timer.tween(0.75, {
                        [self.lemonadeMan] = {
                            arm_up = 2.35
                        }
                    }) : ease(Easing.inOutQuint)
                    Timer.after(0.5, function()
                        Timer.tween(0.5, {
                            [self.temporary_lemon] = {
                                opacity = 1,
                                x = self.temporary_lemon.x + 5
                            }
                        }) : ease(Easing.inOutQuad)
                    end)
                elseif self.currentSplash == 17 then
                    Timer.tween(0.75, {
                        [self.lemonadeMan] = {
                            arm_up = 1
                        }
                    }) : ease(Easing.inOutQuint)
                    : finish(function()
                        Timer.tween(1.5, {
                            [self.lemonadeMan] = {
                                arm_up = 1.45
                            }
                        }) : ease(Easing.inOutQuint)
                    end)
                    self.temporary_lemon:pickup()
                    self.splash:hideLemons()
                elseif not self.has_laddered and self.currentSplash == 18 then
                    self.splash:show(lemon_dialogue[self.currentSplash], true)
                    Lemon(69, -5, self.world, true)
                elseif self.currentSplash == 18 then
                    self.splash:show(lemon_dialogue[20], true)
                    Lemon(85, -8, self.world, true)
                end
            end) : limit(6)
            : finish(function()
                self.lemon_camera = false
                self.currentSplash = 0
                self.camera.smoother = Camera.smooth.damped(15)
                removeTiles(self, 20)
                removeTiles(self, 21)
                removeTiles(self, 18)
                summonTiles(self, 28)
                if not self.has_laddered then
                    summonTiles(self, 27)
                    summonTiles(self, 29)
                    summonTiles(self, 30)
                else
                    summonTiles(self, 31)
                    summonTiles(self, 33)
                    summonTiles(self, 37)
                end
                self.triggers[41].active = true
            end)
        end,
        [37] = function()
            -- Not enough lemons
            self.lemon_camera = true
            self.camera.smoother = Camera.smooth.damped(2)
            summonTiles(self, 20)
            summonTiles(self, 21)
            self.splash:show('Really? You couldn\'t handle collecting three measly lemons?', true)
            Timer.after(3, function()
                Timer.tween(1.5, {
                    [self.lemonadeMan] = {
                        arm_up = math.pi * 6 + 1.45
                    }
                }) : ease(Easing.inOutQuint)
                Timer.tween(2, {
                    [self] = {
                        anvil_opacity = 1
                    }
                }) : ease(Easing.inOutQuad)
                : finish(function()
                    Timer.tween(1.75, {
                        [self.lemonadeMan] = {
                            arm_up = math.pi * 6 + 2.35
                        }
                    }) : ease(Easing.inOutQuint)
                    Timer.tween(1.75, {
                        [self] = {
                            anvil_x = self.player.x - 10,
                            anvil_y = -120
                        }
                    }) : ease(Easing.inOutQuad)
                    : finish(function()
                        Timer.tween(0.4, {
                            [self.lemonadeMan] = {
                                arm_up = math.pi * 6 + 1
                            }
                        }) : ease(Easing.inOutQuint)
                    end)
                    self.splash:show('...prepare to be crushed', true)

                    Timer.after(2, function()
                        Timer.tween(0.15, {
                            [self] = {
                                anvil_x = self.player.x - 5,
                                anvil_y = self.player.y + self.player.h - 16
                            }
                        }) : ease(Easing.inCubic)
                        : finish(function()
                            Timer.tween(0.05, {
                                [self] = {
                                    fade_in_opacity = 1
                                }
                            }) : ease(Easing.inCubic)
                            : finish(function()
                                self.lemon_camera = false
                                self.anvil_opacity = 0
                                self.lemonadeMan.opacity = 0
                                self.stand_opacity = 0
                                self.currentSplash = 0

                                removeTiles(self, 18)
                                removeTiles(self, 19)
                                removeTiles(self, 20)
                                removeTiles(self, 21)
                                removeTiles(self, 22)
                                removeTiles(self, 23)
                                removeTiles(self, 24)
                                removeTiles(self, 36)

                                if not self.has_laddered then
                                    self.player = Player(39 * TILE_SIZE, 8 * TILE_SIZE, self.world, self.splash)
                                    summonTiles(self, 25)
                                    summonTiles(self, 26)
                                    summonTiles(self, 27)
                                    self.triggers[39].active = true
                                else
                                    self.player = Player(104 * TILE_SIZE, -8 * TILE_SIZE, self.world, self.splash)
                                    summonTiles(self, 31)
                                    summonTiles(self, 34)
                                    summonTiles(self, 37)
                                    self.triggers[44].active = true
                                end

                                self.camera.smoother = Camera.smooth.damped(15)
                                self.splash:show('')
                                self.splash:hideLemons()
                                Timer.after(1, function()
                                    Timer.tween(0.75, {
                                        [self] = {
                                            fade_in_opacity = 0
                                        }
                                    }) : ease(Easing.inOutSine)
                                end)
                            end)
                        end)
                    end)
                end)
            end)
        end,
        [38] = function()
            -- Too many lemons
            self.lemon_camera = true
            self.camera.smoother = Camera.smooth.damped(2)
            summonTiles(self, 20)
            summonTiles(self, 21)
            self.splash:show('There\'s a sign here. You can just barely decipher the writing:')

            Timer.every(4, function()
                self.currentSplash = self.currentSplash + 1
                self.splash:show(lemon_dialogue[self.currentSplash], true)
            end) : limit(7)
            : finish(function()
                self.anvil_x = self.player.x
                self.anvil_y = -200
                self.anvil_opacity = 1
                Timer.tween(0.3, {
                    [self] = {
                        anvil_x = self.player.x,
                        anvil_y = self.player.y + self.player.h - 16
                    }
                }) : ease(Easing.inCubic)
                : finish(function()
                    Timer.tween(0.05, {
                        [self] = {
                            fade_in_opacity = 1
                        }
                    }) : ease(Easing.inCubic)
                    : finish(function()
                        self.lemon_camera = false
                        self.anvil_opacity = 0
                        self.lemonadeMan.opacity = 0
                        self.stand_opacity = 0
                        self.currentSplash = 0

                        removeTiles(self, 18)
                        removeTiles(self, 19)
                        removeTiles(self, 20)
                        removeTiles(self, 21)
                        removeTiles(self, 22)
                        removeTiles(self, 23)
                        removeTiles(self, 24)
                        removeTiles(self, 36)

                        if not self.has_laddered then
                            self.player = Player(39 * TILE_SIZE, 8 * TILE_SIZE, self.world, self.splash)
                            summonTiles(self, 25)
                            summonTiles(self, 26)
                            summonTiles(self, 27)
                            self.triggers[39].active = true
                        else
                            self.player = Player(104 * TILE_SIZE, -8 * TILE_SIZE, self.world, self.splash)
                            summonTiles(self, 31)
                            summonTiles(self, 34)
                            summonTiles(self, 37)
                            self.triggers[44].active = true
                        end

                        self.camera.smoother = Camera.smooth.damped(15)
                        self.splash:show('')
                        self.splash:hideLemons()
                        Timer.after(1, function()
                            Timer.tween(0.75, {
                                [self] = {
                                    fade_in_opacity = 0
                                }
                            }) : ease(Easing.inOutSine)
                        end)
                    end)
                end)
            end)
        end,
        -- Lemonade to ladder
        [39] = function()
            self.triggers[40].active = true
            self.splash:show('A throbbing pain pierces your skull as you contemplate your failure')
        end,
        [40] = function()
            removeTiles(self, 26)
            summonTiles(self, 12)
            summonTiles(self, 13)
            summonTiles(self, 16)
            summonTiles(self, 35)
            self.triggers[16].active = true
            self.splash:show('Knowing this world the way you did, it wouldn\'t\nbe long before it threw something else your way')
        end,
        [41] = function()
            self.lemonadeMan.opacity = 0
            self.stand_opacity = 0
            if not self.has_laddered then
                self.triggers[42].active = true
            else
                self.triggers[50].active = true
            end
            self.triggers[49].active = true
            self.splash:show('')
        end,
        [42] = function()
            -- Create a new player because collisions are
            -- broken and so is my mind
            self.camera.smoother = Camera.smooth.none()
            self.player = Player(self.player.x - TILE_SIZE * 74, self.player.y + TILE_SIZE * 13, self.world, self.splash)

            self.background_x = self.background_x - TILE_SIZE * 6
            self.background_y = self.background_y - TILE_SIZE * 6.45

            local items, len = self.world:getItems()

            for i = 1, len do
                local item = items[i]
                if item.name == 'lemon' then
                    self.world:remove(item)
                end
            end

            removeTiles(self, 18)
            removeTiles(self, 19)
            removeTiles(self, 20)
            removeTiles(self, 21)
            removeTiles(self, 22)
            removeTiles(self, 23)
            removeTiles(self, 24)
            removeTiles(self, 28)
            removeTiles(self, 29)
            removeTiles(self, 36)
            summonTiles(self, 12)
            summonTiles(self, 13)
            summonTiles(self, 16)
            self.triggers[16].active = true
            self.triggers[43].active = true
        end,
        [43] = function()
            self.camera.smoother = Camera.smooth.damped(15)
            self.triggers[52].active = true
            self.splash:show('As you walked, you wondered how this \'relic\' could help you...')
        end,
        -- Lemonade crush to end
        [44] = function()
            self.triggers[45].active = true
            self.splash:show('A throbbing pain pierces your skull as you contemplate your failure')
        end,
        [45] = function()
            self.triggers[53].active = true
            self.splash:show('It seemed as if it could only go down from here')
        end,
        -- Ladder to end
        [46] = function()
            self.triggers[47].active = true
            self.splash:show('You begin to question where this world was trying to bring you')
        end,
        [47] = function()
            summonTiles(self, 31)
            summonTiles(self, 37)
            self.triggers[53].active = true
            self.splash:show('A leap of faith... or certain doom?')
        end,
        [48] = function()
            self.triggers[53].active = true
            self.splash:show('Another trap?')
        end,
        -- Lemonade success to end
        [49] = function()
            -- random
            self.splash:show('...nothing but a fading memory...')
            Timer.after(5, function()
                self.splash:show('')
            end)
        end,
        [50] = function()
            self.splash:show('Though you had been successful...')
            self.triggers[51].active = true
        end,
        [51] = function()
            self.splash:show('It still felt a bit... empty')
            self.triggers[53].active = true
            self.triggers[59].active = true
        end,
        [52] = function()
            self.splash:show('Surely it wouldn\'t hurt to try')
        end,
        -- End
        [53] = function()
            Timer.after(2, function()
                removeTiles(self, 31)
            end)
            self.triggers[54].active = true
            self.triggers[55].active = true
            self.splash:show('...and the world was silent...')
        end,
        [54] = function()
            summonTiles(self, 38)
            summonTiles(self, 39)
            self.triggers[55].active = false
            self.triggers[56].active = true
            self.splash:show('In the silence, you wonder if it could have ended differently')
        end,
        [55] = function()
            summonTiles(self, 38)
            summonTiles(self, 39)
            self.triggers[54].active = false
            self.triggers[56].active = true
            self.splash:show('In the silence, you wonder if it could have ended differently')
        end,
        [56] = function()
            self.triggers[57].active = true
            if self.skippedLadder then
                self.splash:show('What if you had tried to climb that ladder?')
            else
                self.splash:show('What if you had never climbed that ladder?')
            end
        end,
        [57] = function()
            removeTiles(self, 37)
            removeTiles(self, 39)
            self.triggers[58].active = true
            if self.skippedParkour then
                self.splash:show('What if you hadn\'t given up?')
            else
                self.splash:show('What if you could have gone another way?')
            end
        end,
        [58] = function()
            -- Final cutscene
            Timer.after(2, function()
                removeTiles(self, 38)
            end)
            summonTiles(self, 40)
            self.splash:show('Would you have been happier then, in your \'perfect\' world?')

            Timer.tween(5, {
                [self] = {
                    cinematic_fade = 0.2
                }
            }) : ease(Easing.inOutQuad)

            Timer.after(8, function()
                self.splash:show('...would your experiences have meant anything?')
                Timer.after(7, function()
                    self.splash:show('')
                end)
            end)

            Timer.tween(16, {
                [self] = {
                    fade_out_x = TILE_SIZE * 25
                }
            }) : ease(Easing.inCirc)
            : finish(function()
                self.splash:show('')
                Timer.after(2, function()
                    self.splash:show('\n\n\n\n\n\n\n\n\nWould your life have meant anything?')
                    Timer.after(5, function()
                        self.splash:show('')
                        Timer.after(3, function()
                            State.switch(States.start)
                        end)
                    end)
                end)
            end)
        end,
        -- Misc.
        [59] = function()
            -- Force the player to go down
            removeTiles(self, 28)
            summonTiles(self, 41)
        end,
    }

    -- Add actions to triggers
    for i = 1, math.min(#self.triggers, #self.actions) do
        self.triggers[i].func = self.actions[i]
    end

    -- First trigger is active
    self.triggers[1].active = true

    -- DEBUG: activate all triggers up to a certain point
    if DEBUG then
        for i = 1, 7 do
            self.triggers[i]:trigger()
        end
    end

    -- Player
    self.player = Player(TILE_SIZE * -8, TILE_SIZE, self.world, self.splash)
    if DEBUG then
        self.player = Player(TILE_SIZE * 48, TILE_SIZE * -5, self.world, self.splash)
    end

    self.lemonadeMan = LemonadeMan(58 * TILE_SIZE, -0.5 * TILE_SIZE, self.player)

    lg.setBackgroundColor(Colors[16])

    -- Fade in
    self.fade_in_opacity = 1
    Timer.after(0.5, function()
        Timer.tween(0.75, {
            [self] = {fade_in_opacity = 0}
        }) : ease(Easing.inOutSine)
    end)

    -- Needed for ladder
    self.ladderTimeStart = 0
    self.ladderTimeEnd = 0
    self.shuffled = false
    self.splashTime = 0
    self.humanTime = ''
    self.has_laddered = false
    self.skippedLadder = false

    -- Parallax background
    self.background_x = -440
    self.background_y = -414
    self.vertical_add = 0
    self.loops = {
        {
            x1 = 0,
            x2 = 400,
            y1 = 0,
            y2 = 300,
            speed = 1,
            img = Graphics['layer-3']
        },
        {
            x1 = 0,
            x2 = 400,
            y1 = 0,
            y2 = 300,
            speed = 1.1,
            img = Graphics['layer-2']
        },
        {
            x1 = 0,
            x2 = 400,
            y1 = 0,
            y2 = 300,
            speed = 1.2,
            img = Graphics['layer-1']
        },
    }

    -- LEMONS!!!
    self.stand_opacity = 0
    self.sign_opacity = 0
    self.anvil_opacity = 0
    self.anvil_x = self.lemonadeMan.x
    self.anvil_y = -100
    self.lemon_camera = false
    self.has_lemoned = false

    -- Misc.
    self.currentSplash = 0
    self.skippedParkour = false
    self.fade_out_x = 0
    self.cinematic_fade = 0

end

function game:resume()
    lg.setBackgroundColor(Colors[16])
end

function game:update(dt)

    self.player:update(dt)

    self.splash:update(dt)

    if self.triggers[20].active == true then
        ladderTimer(self)
    end

    Timer.update(dt)

    if not self.lemon_camera then
        self.camera:lockPosition(self.player.x + self.player.w / 2, self.player.y - VIRT_HEIGHT / 20)
    else
        self.camera:lockPosition(TILE_SIZE * 56.5, TILE_SIZE * -1.5)
    end

    -- Lemons
    local items, len = self.world:getItems()

    for i = 1, len do
        local item = items[i]
        if item.name == 'lemon' then
            item:update(dt)
        end
    end

    -- Parallax logic
    if not self.lemon_camera then
        self.background_x = self.background_x + self.player.dx + 0.15
    else
        self.background_x = self.background_x + 0.15
    end

    for _, loop in ipairs(self.loops) do
        -- Horizontal wrapping
        local wrap_x = self.player.x + self.player.w / 2 + 200

        if self.lemon_camera then
            wrap_x = 200 + TILE_SIZE * 56.5
        end

        if self.background_x * loop.speed + loop.x1 >= wrap_x then
            loop.x1 = loop.x1 - 800
        elseif self.background_x * loop.speed + loop.x1 < wrap_x - 800 then
            loop.x1 = loop.x1 + 800
        end

        if self.background_x * loop.speed + loop.x2 >= wrap_x then
            loop.x2 = loop.x2 - 800
        elseif self.background_x * loop.speed + loop.x2 < wrap_x - 800 then
            loop.x2 = loop.x2 + 800
        end

        -- Vertical wrapping
        local wrap_y = self.player.y + self.player.h / 2 + 110

        if self.background_y + loop.y1 >= wrap_y then
            loop.y1 = loop.y1 - 600
        elseif self.background_y + loop.y1 < wrap_y - 600 then
            loop.y1 = loop.y1 + 600
        end

        if self.background_y + loop.y2 >= wrap_y then
            loop.y2 = loop.y2 - 600
        elseif self.background_y + loop.y2 < wrap_y - 600 then
            loop.y2 = loop.y2 + 600
        end
    end

    if self.triggers[20].active then
        self.background_y = self.player.y - 400 + self.vertical_add
        self.vertical_add = self.vertical_add + -self.player.dy + 0.25
    else
        self.vertical_add = 0
    end
    LastKeyPress = {}
end

function game:keypressed(key, code)
    if key == 'kp1' then
    elseif key == 'kp2' then
        Lume.hotswap("src.class.LemonadeMan")
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
    lg.clear(0, 0, 0, 0)

    -- Draw background
    lg.setColor(Colors[16])

    if not self.lemon_camera then
        lg.rectangle('fill', self.player.x + self.player.w / 2 - 225, self.player.y - 305, 450, 450)
    else
        lg.rectangle('fill', TILE_SIZE * 56.5 - 250, TILE_SIZE * -1.5 - 230, 500, 400)
    end

    if DEBUG then
        lg.setColor(Colors[11])
        lg.rectangle('line', self.player.x + self.player.w / 2 - 200, self.player.y - 180, 400, 300)
    end

    -- Parallax
    for i = 1, 3 do
        local loop = self.loops[i]

        lg.setColor(1, 1, 1, (i + 1) / 5)
        lg.draw(loop.img, self.background_x * loop.speed + loop.x1, self.background_y + loop.y1)
        lg.draw(loop.img, self.background_x * loop.speed + loop.x1, self.background_y + loop.y2)
        lg.draw(loop.img, self.background_x * loop.speed + loop.x2, self.background_y + loop.y1)
        lg.draw(loop.img, self.background_x * loop.speed + loop.x2, self.background_y + loop.y2)
    end

    lg.setColor(1, 1, 1, 1)

    local items, len = self.world:getItems()

    for i = 1, len do
        local item = items[i]
        if item.x + TILE_SIZE >= self.camera.x - VIRT_WIDTH / 4 and item.x <= self.camera.x + VIRT_WIDTH / 4 and item.y + TILE_SIZE >= self.camera.y - VIRT_HEIGHT / 3 and item.y <= self.camera.y + VIRT_HEIGHT / 3 then
            if item.name == 'tile' or item.name == 'lemon' then
                item:render()
            end
        end
    end

    if self.stand_opacity > 0 then
        lg.setColor(1, 1, 1, self.stand_opacity)
        lg.draw(Graphics['stand'], TILE_SIZE * 56, -40)
    end

    if self.sign_opacity > 0 then
        lg.setColor(1, 1, 1, self.sign_opacity)
        lg.draw(Graphics['sign'], TILE_SIZE * 56, -40)
    end

    lg.setColor(1, 1, 1, 1)

    if self.lemonadeMan.opacity > 0 then
        self.lemonadeMan:render()
    end

    self.player:render()

    if self.anvil_opacity > 0 then
        lg.setColor(1, 1, 1, self.anvil_opacity)
        lg.draw(Graphics['anvil'], self.anvil_x - 10, self.anvil_y)
    end

    if self.cinematic_fade > 0 then
        lg.setColor(Colors[2][1], Colors[2][2], Colors[2][3], self.cinematic_fade)
        lg.rectangle('fill', self.player.x + self.player.w / 2 - 225, self.player.y - 305, 450, 450)
    end

    if self.cinematic_fade > 0 then

        lg.setColor(Colors[4][1], Colors[4][2], Colors[4][3], 0.75)
        -- Left
        lg.rectangle('fill', TILE_SIZE * 16.5 + self.fade_out_x, TILE_SIZE * 50, TILE_SIZE * 33, TILE_SIZE * 20)
        lg.rectangle('fill', TILE_SIZE * 16.5 + self.fade_out_x, TILE_SIZE * 50, TILE_SIZE * 32.5, TILE_SIZE * 20)
        lg.rectangle('fill', TILE_SIZE * 16.5 + self.fade_out_x, TILE_SIZE * 50, TILE_SIZE * 32, TILE_SIZE * 20)
        lg.rectangle('fill', TILE_SIZE * 16.5 + self.fade_out_x, TILE_SIZE * 50, TILE_SIZE * 31.5, TILE_SIZE * 20)
        lg.rectangle('fill', TILE_SIZE * 16.5 + self.fade_out_x, TILE_SIZE * 50, TILE_SIZE * 31, TILE_SIZE * 20)
        -- Right
        lg.rectangle('fill', TILE_SIZE * 89.5 - self.fade_out_x, TILE_SIZE * 50, TILE_SIZE * 33, TILE_SIZE * 20)
        lg.rectangle('fill', TILE_SIZE * 90   - self.fade_out_x, TILE_SIZE * 50, TILE_SIZE * 32.5, TILE_SIZE * 20)
        lg.rectangle('fill', TILE_SIZE * 90.5 - self.fade_out_x, TILE_SIZE * 50, TILE_SIZE * 32, TILE_SIZE * 20)
        lg.rectangle('fill', TILE_SIZE * 91   - self.fade_out_x, TILE_SIZE * 50, TILE_SIZE * 31.5, TILE_SIZE * 20)
        lg.rectangle('fill', TILE_SIZE * 91.5 - self.fade_out_x, TILE_SIZE * 50, TILE_SIZE * 31, TILE_SIZE * 20)
    end

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

    if self.fade_in_opacity > 0 then
        lg.setColor(Colors[4][1], Colors[4][2], Colors[4][3], self.fade_in_opacity)
        lg.rectangle('fill', 0, 0, VIRT_WIDTH, VIRT_HEIGHT)
    end

    Resolution.stop()
end

return game
