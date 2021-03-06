#
class Bullet < ShortLived
  
  it_is_a Shot
  
  def initialize window
    self.lifetime = 200 + rand(100)
    
    super window
    
    @image = Gosu::Image.new window, "media/bullet.png", false
    
    @shape = CP::Shape::Circle.new(CP::Body.new(0.1, 0.1),
                                   1.0,
                                   CP::Vec2.new(0.0, 0.0))
    @shape.collision_type = :projectile
    
    self.friction = 0.0001
    self.velocity = 6 + rand(2)
    
    # @sound = Gosu::Sample.new window, 'media/sounds/cannon-02.wav'
    # @sound.play
  end
  
  # def destroy
  #   explosion = SmallExplosion.new window
  #   explosion.warp position
  #   window.register explosion
  #   super
  # end
  
  def validate_position
    
  end
  
  def draw
    @image.draw_rot position.x, position.y, ZOrder::Player, drawing_rotation
  end
  
end