-- All libraries and assets that we will need


-- [[ Libraries ]]
Bump        = require 'libs.bump'
Camera      = require 'libs.camera'
Class       = require 'libs.class'
Easing      = require 'libs.easing'
Inspect     = require 'libs.inspect'
Lume        = require 'libs.lume'
Resolution  = require 'libs.resolution'
State       = require 'libs.state'
Timer       = require 'libs.timer'

-- [[ Packages ]]
require 'src.shortcuts'
require 'src.assets'
require 'src.globals'

-- [[ Classes ]]
require 'src.class.Button'
require 'src.class.Trigger'
require 'src.class.Player'
require 'src.class.Tile'
require 'src.class.Splash'

-- [[ States ]]
States = {
    config  = require 'states.config',
    game    = require 'states.game',
    intro   = require 'states.intro',
    start   = require 'states.start',
}