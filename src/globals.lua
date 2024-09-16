-- Global variables to be used everywhere

DEBUG = true

WIN_WIDTH, WIN_HEIGHT = lg.getDimensions()
VIRT_WIDTH  = 800
VIRT_HEIGHT = 600

LastKeyPress = {}

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

Colors = {
    {0.023529412, 0.043137255, 0.066666667},
    {0.047058824, 0.062745098, 0.137254902},
    {0.062745098, 0.094117647, 0.180392157},
    {0.094117647, 0.149019608, 0.203921569},
    {0.368627451, 0.101960784, 0.125490196},
    {0.552941176, 0.250980392, 0.184313725},
    {0.745098039, 0.474509804, 0.309803922},
    {0.890196078, 0.705882353, 0.478431373},
}