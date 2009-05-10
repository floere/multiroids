# A city is shootable, gives points.
#
class City < Moveable
  
  include EarthOriented
  
  def initialize window
    super window
    
    @image = Gosu::Image.new window, "media/city.png", false
    
    @shape = CP::Shape::Circle.new CP::Body.new(10.0, 75.0), 11.0, CP::Vec2.new(0, 0)
    @shape.collision_type = :city
  end
  
  def validate_position
    align_to_earth
  end
  
  def draw
    @image.draw_rot self.position.x, self.position.y, ZOrder::Player, drawing_rotation
  end
end