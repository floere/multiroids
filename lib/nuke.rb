# This game will have multiple Players in the form of a ship.
#
class Nuke < Moveable
  
  attr_reader :score
  
  def initialize window
    super window
    
    body = CP::Body.new 10.0, 75.0
    
    shape_array = [CP::Vec2.new(-10.0, -10.0), CP::Vec2.new(-10.0, 10.0), CP::Vec2.new(10.0, 1.0), CP::Vec2.new(10.0, -1.0)]
    @shape = CP::Shape::Poly.new body, shape_array, CP::Vec2.new(0,0)
    
    @image = Gosu::Image.new window, "media/nuke.png", false
    
    # up-/downgradeable
    @rotation           = 100.0
    @acceleration       = 800.0
    @deceleration       = 100.0
    @max_speed          = 200.0
    
    @shape.collision_type = :nuke
  end
  
  # TODO extract into module
  #
  def target *targets
    
  end
  
  def draw
    @image.draw_rot position.x, position.y, ZOrder::Player, drawing_rotation, 1.0, 1.0, 1.0, 1.0
  end
end