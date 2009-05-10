class Puff < ShortLived
  
  def initialize window
    self.lifetime = 1
    
    super window
    
    @image = Gosu::Image::load_tiles window, "media/smoke.png", 10, 10, false
    
    @shape = CP::Shape::Circle.new CP::Body.new(0.1, 0.1), 0.5, CP::Vec2.new(0, 0)
    
    @shape.collision_type = :ambient
  end
  
  def draw
    image = @image[Gosu::milliseconds / 200 % @image.size];
    image.draw_rot self.position.x, self.position.y, ZOrder::Player, drawing_rotation
  end
  
end