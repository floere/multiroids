# A city is shootable, gives points.
#
class Cow < Moveable
  
  include EarthOriented
  include Lives
  
  def initialize window
    super window
    
    @image = Gosu::Image::load_tiles window, "media/cow.png", 32, 27, false
    
    @shape = CP::Shape::Circle.new CP::Body.new(12.0, 12.0), 11.0, CP::Vec2.new(0, 0)
    @shape.collision_type = :cow
    
    self.lives = 100
  end
  
  def gravity_strikes
    self.position += (direction_to_earth*0.05)
  end
  
  def validate_position
    align_to_earth
    gravity_strikes
  end
  
  def draw
    image = @image[Gosu::milliseconds / 100 % @image.size];
    image.draw_rot self.position.x, self.position.y, ZOrder::Player, drawing_rotation
    # @image.draw_rot self.position.x, self.position.y, ZOrder::Player, drawing_rotation
  end
end