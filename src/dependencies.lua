-- All libraries and assets that we will need


-- [[ Libraries ]]
Bump        = require 'libs.bump'
Camera      = require 'libs.camera'
Class       = require 'libs.class'
Inspect     = require 'libs.inspect'
Lume        = require 'libs.lume'
Resolution  = require 'libs.resolution'
State       = require 'libs.state'
Timer       = require 'libs.timer'

-- [[ Packages ]]
require 'src.shortcuts'
require 'src.globals'
require 'src.assets'

-- [[ Classes ]]
require 'src.class.Button'

-- [[ States ]]
States = {
    start   = require 'states.start',
    game    = require 'states.game',
    config  = require 'states.config'
}