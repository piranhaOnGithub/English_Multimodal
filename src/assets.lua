-- Assets to be used in the game

Audio = {
    ['click']   = la.newSource('assets/audio/click.ogg', 'static'),
    ['fall']    = la.newSource('assets/audio/fall.ogg', 'static'),
    ['hover']   = la.newSource('assets/audio/hover.ogg', 'static'),
    ['jump']    = la.newSource('assets/audio/jump.ogg', 'static'),
    ['ladder']  = la.newSource('assets/audio/ladder.ogg', 'static'),
    ['lemon']   = {
        la.newSource('assets/audio/lemon-1.ogg', 'static'),
        la.newSource('assets/audio/lemon-2.ogg', 'static'),
        la.newSource('assets/audio/lemon-3.ogg', 'static'),
    },
    ['smash']   = la.newSource('assets/audio/smash.ogg', 'static'),
    ['walk']    = la.newSource('assets/audio/step.ogg', 'static'),

    ['music-1'] = la.newSource('assets/audio/not-to-notice.ogg', 'stream'),
    ['music-2'] = la.newSource('assets/audio/soft-music-box.ogg', 'stream'),
}
Graphics = {
    ['anvil']   = lg.newImage('assets/graphics/you-failed.png'),
    ['arrows']  = lg.newImage('assets/graphics/arrows.png'),
    ['layer-1'] = lg.newImage('assets/graphics/layer-1.png'),
    ['layer-2'] = lg.newImage('assets/graphics/layer-2.png'),
    ['layer-3'] = lg.newImage('assets/graphics/layer-3.png'),
    ['lemon']   = lg.newImage('assets/graphics/definitely-a-lemon.png'),
    ['lime']    = lg.newImage('assets/graphics/definitely-a-lime.png'),
    ['sign']    = lg.newImage('assets/graphics/too-many-lemons.png'),
    ['stand']   = lg.newImage('assets/graphics/limeade-stand.png'),
    ['tileset'] = lg.newImage('assets/graphics/tileset.png'),
    ['title']   = lg.newImage('assets/graphics/title.png'),
    ['stars']   = lg.newImage('assets/graphics/title-stars.png'),
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