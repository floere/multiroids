#
class Bullet < ShortLived
  
  it_is_a Shot
  it_is_a Generator
  generates Puff, 0
  
  def initialize window
    self.lifetime = 400 + rand(700)
    
    super window
    
    @image = Gosu::Image.new window, "media/bullet.png", false
    
    @shape = CP::Shape::Circle.new(CP::Body.new(0.1, 0.1),
                                   1.0,
                                   CP::Vec2.new(0.0, 0.0))
    @shape.collision_type = :bullet
    
    self.friction = 0.0001
    self.velocity = 5 + rand(1)
    
    start_generating
  end
  
  def destroy
    explosion = SmallExplosion.new window
    explosion.warp position
    window.register explosion
    super
  end
  
  def validate_position
    
  end
  
  def draw
    @image.draw_rot position.x, position.y, ZOrder::Player, drawing_rotation
  end
  
end