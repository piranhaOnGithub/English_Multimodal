-- Global variables to be used everywhere

DEBUG = true

WIN_WIDTH, WIN_HEIGHT = lg.getDimensions()
VIRT_WIDTH  = 300
VIRT_HEIGHT = 180


local function makeFont(path)
    return setmetatable({}, {
        __index = function(t, size)
            local f = love.graphics.newFont(path, size)
            rawset(t, size, f)
            return f
        end
    })
end

Fonts = {
    default = nil,

    bold        = makeFont 'assets/fonts/Roboto-Bold.ttf',
    monospace   = makeFont 'assets/fonts/RobotoMono-Regular.ttf',
}
Fonts.default = Fonts.bold