## File: ChipmunkIntegration.rb
## Author: Dirk Johnson
## Version: 1.0.0
## Date: 2007-10-05
## License: Same as for Gosu (MIT)
## Comments: Based on the Gosu Ruby Tutorial, but incorporating the Chipmunk Physics Engine
## See http://code.google.com/p/gosu/wiki/RubyChipmunkIntegration for the accompanying text.

require 'rubygems'
require 'activesupport'
require 'gosu'
require 'chipmunk' # A physics framework.

SCREEN_WIDTH = 1000
SCREEN_HEIGHT = 600

# The number of steps to process every Gosu update
# The Player ship can get going so fast as to "move through" a
# star without triggering a collision; an increased number of
# Chipmunk step calls per update will effectively avoid this issue
SUBSTEPS = 10

require 'lib/numeric'
require 'lib/zorder'

require 'lib/targeting'
require 'lib/moveable'
require 'lib/turnable'
require 'lib/accelerateable'
require 'lib/earth_oriented'
require 'lib/targetable'
require 'lib/shooter'
require 'lib/shot'
require 'lib/hurting'
require 'lib/generator'

require 'lib/short_lived'
require 'lib/puff'
require 'lib/small_explosion'
require 'lib/player'
require 'lib/gun'
require 'lib/nuke_launcher'
require 'lib/asteroid'
require 'lib/bullet'
require 'lib/controls'
require 'lib/earth'
require 'lib/city'
require 'lib/nuke'
require 'lib/game_window'

EARTH_POSITION = CP::Vec2.new(SCREEN_WIDTH / 2, SCREEN_HEIGHT + 100)
EARTH_RADIUS   = 320

window = GameWindow.new
window.show
