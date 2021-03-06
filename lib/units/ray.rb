#
class Ray < ShortLived
  
  it_is   EarthOriented
  it_is_a Shot
  
  def initialize window
    self.lifetime = 50
    
    super window
    
    @image = Gosu::Image.new window, "media/ray.png", false
    
    @shape = CP::Shape::Circle.new(CP::Body.new(0.1, 0.1),
                                   5.0,
                                   CP::Vec2.new(0.0, 0.0))
    @shape.collision_type = :ray
    
    self.friction = 0.1
    self.velocity = 50 + rand(30)
  end
  
  def validate_position
    closer * 0.01
  end
  
  def draw
    @image.draw_rot position.x, position.y, ZOrder::Player, drawing_rotation
  end
  
end