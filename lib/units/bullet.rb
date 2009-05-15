#
class Bullet < ShortLived
  
  it_is_a Shot
  
  def initialize window
    self.lifetime = 50
    
    super window
    
    @image = Gosu::Image.new window, "media/bullet.png", false
    
    @shape = CP::Shape::Circle.new(CP::Body.new(0.1, 0.1),
                                   1.0,
                                   CP::Vec2.new(0.0, 0.0))
    @shape.collision_type = :bullet
    
    self.friction = 0.0001
    self.velocity = 70 + rand(30)
  end
  
  def validate_position
    
  end
  
  def draw
    @image.draw_rot position.x, position.y, ZOrder::Player, drawing_rotation
  end
  
end