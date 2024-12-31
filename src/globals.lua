-- Global variables to be used everywhere

DEBUG = not not true

VIRT_WIDTH  = 800
VIRT_HEIGHT = 600

TILE_SIZE = 30

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
    display     = makeFont 'assets/fonts/Abaddon-Bold.ttf',
    light       = makeFont 'assets/fonts/Abaddon-Light.ttf'
}
Fonts.default = Fonts.display

Colors = {
    -- Grays
    {0.662745098, 0.611764706, 0.552941176},
    {0.549019608, 0.486274510, 0.474509804},
    {0.392156863, 0.325490196, 0.333333333},
    {0.294117647, 0.239215686, 0.266666667},
    -- Browns
    {0.866666667, 0.811764706, 0.600000000},
    {0.800000000, 0.658823529, 0.482352941},
    {0.658823529, 0.541176471, 0.368627451},
    {0.517647059, 0.427450980, 0.349019608},
    -- Reds
    {0.725490196, 0.478431373, 0.376470588},
    {0.611764706, 0.321568627, 0.305882353},
    {0.466666667, 0.258823529, 0.317647059},
    -- Greens
    {0.490196078, 0.482352941, 0.384313725},
    {0.666666667, 0.635294118, 0.364705882},
    -- Blues
    {0.556862745, 0.623529412, 0.490196078},
    {0.356862745, 0.490196078, 0.450980392},
    {0.305882353, 0.329411765, 0.388235294},

    -- Old
    -- {0.023529412, 0.043137255, 0.066666667},
    -- {0.047058824, 0.062745098, 0.137254902},
    -- {0.062745098, 0.094117647, 0.180392157},
    -- {0.094117647, 0.149019608, 0.203921569},
    -- {0.368627451, 0.101960784, 0.125490196},
    -- {0.552941176, 0.250980392, 0.184313725},
    -- {0.745098039, 0.474509804, 0.309803922},
    -- {0.890196078, 0.705882353, 0.478431373},
}