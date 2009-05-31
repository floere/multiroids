# An enemy moves towards the players.
#
class Enemy < Moveable
  
  include Lives
  include HorizonOriented
  include Targetable
  
  lives 10
  
  def initialize window
    super window
    
    @image = Gosu::Image::load_tiles window, "media/spaceship.png", 22, 22, false
    
    @shape = CP::Shape::Circle.new CP::Body.new(1.0, 1.0), 11.0, CP::Vec2.new(0, 0)
    @shape.collision_type = :enemy
    
    self.rotation = -Math::PI/2
    
    after_initialize
  end
  
  def validate_position
    self.position -= horizontal / 20
  end
  
  def draw
    image = @image[Gosu::milliseconds / 100 % @image.size];
    image.draw_rot self.position.x, self.position.y, ZOrder::Player, drawing_rotation
  end
end