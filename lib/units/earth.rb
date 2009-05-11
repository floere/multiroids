# The earth.
#
class Earth < Moveable
  
  def initialize window
    super window
    
    @image = Gosu::Image.new window, "media/earth.png", false
    
    @shape = CP::Shape::Circle.new CP::Body.new(100_000_000, 100_000_000), EARTH_RADIUS, CP::Vec2.new(0, 0) # CP::Vec2.new(0.0, 200.0)
    @shape.collision_type = :earth
    
    self.position = EARTH_POSITION
  end
  
  def draw
    @image.draw position.x-EARTH_RADIUS, position.y-EARTH_RADIUS, ZOrder::Player, 0.5, 0.5
  end
  
end