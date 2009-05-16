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

SCREEN_WIDTH = 1200
SCREEN_HEIGHT = 700

# The number of steps to process every Gosu update
# The Player ship can get going so fast as to "move through" a
# star without triggering a collision; an increased number of
# Chipmunk step calls per update will effectively avoid this issue
SUBSTEPS = 10

require 'lib/numeric'
require 'lib/zorder'
require 'lib/scheduling'
require 'lib/initializer_hooks'

require 'lib/thing'
require 'lib/targeting'
require 'lib/moveable'
require 'lib/turnable'
require 'lib/accelerateable'
require 'lib/earth_oriented'
require 'lib/horizon_oriented'
require 'lib/top_down_oriented'
require 'lib/targetable'
require 'lib/shooter'
require 'lib/shot'
require 'lib/hurting'
require 'lib/generator'
require 'lib/lives'
require 'lib/mother_ship'
require 'lib/child'
require 'lib/waves'

require 'lib/short_lived'
require 'lib/controls'

require 'lib/ambient/puff'
require 'lib/ambient/small_explosion'

require 'lib/units/gun'
require 'lib/units/torpedo'

require 'lib/units/player'
require 'lib/units/first_mate'
require 'lib/units/captain'
require 'lib/units/admiral'

require 'lib/units/enemy'
require 'lib/units/cow'
require 'lib/units/nuke_launcher'
require 'lib/units/asteroid'
require 'lib/units/bullet'
require 'lib/units/earth'
require 'lib/units/city'
require 'lib/units/nuke'
require 'lib/units/ray'