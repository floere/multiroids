#
class Bullet < ShortLived
  
  include EarthOriented
  include Shot
  
  def initialize window
    self.lifetime = 2
    
    super window
    
    @image = Gosu::Image.new window, "media/bullet.png", false
    
    @shape = CP::Shape::Circle.new(CP::Body.new(0.1, 0.1),
                                   1.0,
                                   CP::Vec2.new(0.0, 0.0))
    @shape.collision_type = :bullet
    
    self.friction = 0.1
    self.velocity = 100
  end
  
  def validate_position
    closer * 0.05
  end
  
  def draw
    @image.draw_rot(position.x, position.y, ZOrder::Player, drawing_rotation)
  end
  
end