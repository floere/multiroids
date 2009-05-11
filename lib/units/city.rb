# A city is shootable, gives points.
#
class City < Moveable
  
  include EarthOriented
  include Lives
  
  def initialize window
    super window
    
    @image = Gosu::Image.new window, "media/city.png", false
    
    @shape = CP::Shape::Circle.new CP::Body.new(10000.0, 10000.0), 11.0, CP::Vec2.new(0, 0)
    @shape.collision_type = :city
    
    self.lives = 100
  end
  
  def validate_position
    align_to_earth
  end
  
  def draw
    @image.draw_rot self.position.x, self.position.y, ZOrder::Player, drawing_rotation
  end
end