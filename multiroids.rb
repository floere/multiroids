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

SCREEN_WIDTH = 640
SCREEN_HEIGHT = 480

# The number of steps to process every Gosu update
# The Player ship can get going so fast as to "move through" a
# star without triggering a collision; an increased number of
# Chipmunk step calls per update will effectively avoid this issue
SUBSTEPS = 10

require 'lib/numeric'
require 'lib/zorder'
require 'lib/moveable'
require 'lib/player'
require 'lib/asteroid'
require 'lib/bullet'
require 'lib/game_window'

window = GameWindow.new
window.show
