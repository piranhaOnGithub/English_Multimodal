-- Assets to be used in the game

Audio = {
    ['hover'] = la.newSource('assets/audio/hover.ogg', 'static'),
    ['click'] = la.newSource('assets/audio/click.ogg', 'static'),
}
Graphics = {
    ['layer-1'] = lg.newImage('assets/graphics/layer-1.png'),
    ['layer-2'] = lg.newImage('assets/graphics/layer-2.png'),
    ['layer-3'] = lg.newImage('assets/graphics/layer-3.png'),
    ['lemon']   = lg.newImage('assets/graphics/definitely-a-lemon.png'),
    ['stand']   = lg.newImage('assets/graphics/limeade-stand.png'),
    ['tileset'] = lg.newImage('assets/graphics/tileset.png'),
    tile = {},
}

-- Insert tiles from spritesheet
local size      = 10
local width     = 70
local height    = 50
for y = 0, height - size, size do
    for x = 0, width - size, size do
        table.insert(Graphics.tile, lg.newQuad(x, y, size, size, width, height))
    end
end