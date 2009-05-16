# This game will have multiple Players in the form of a ship.
#
class Torpedo < ShortLived
  
  include Targeting
  include Turnable
  include Accelerateable
  include Shot
  include Generator
  
  generates Puff, 3
  
  attr_reader :score
  
  def initialize window
    self.lifetime = 800
    
    super window
    
    body = CP::Body.new 10.0, 75.0
    
    shape_array = [CP::Vec2.new(0, 0), CP::Vec2.new(10, 0), CP::Vec2.new(10, 5), CP::Vec2.new(0, 5)]
    @shape = CP::Shape::Poly.new body, shape_array, CP::Vec2.new(0,0)
    
    @image = Gosu::Image.new window, "media/torpedo.png", false
    
    # up-/downgradeable
    self.turn_speed     = 0.5
    self.acceleration   = 0.5
    
    self.friction       = 50.0
    
    @shape.collision_type = :nuke
    
    self.velocity = 2
    
    start_generating
  end
  
  def draw
    @image.draw_rot position.x, position.y, ZOrder::Player, drawing_rotation, 1.0, 1.0, 1.0, 1.0
  end
end