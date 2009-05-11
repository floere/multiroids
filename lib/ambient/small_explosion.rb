class SmallExplosion < ShortLived
  
  include Hurting
  
  def initialize window
    self.lifetime = 15
    
    super window
    
    @image = Gosu::Image::load_tiles window, "media/small_explosion.png", 20, 20, false
    
    @shape = CP::Shape::Circle.new CP::Body.new(1_000, 1_000), 5.0, CP::Vec2.new(0, 0)
    
    @shape.collision_type = :explosion
  end
  
  def draw
    image = @image[Gosu::milliseconds / 300 % @image.size];
    image.draw_rot self.position.x, self.position.y, ZOrder::Player, drawing_rotation
  end
  
end