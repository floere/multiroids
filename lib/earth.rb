#
#
class Earth < Moveable
  
  def initialize window
    super window
    
    @image = Gosu::Image.new window, "media/earth.png", false
    
    @shape = CP::Shape::Circle.new CP::Body.new(100_000, 100), 640/2, CP::Vec2.new(0.0, 0.0)
    @shape.collision_type = :earth
    
    warp CP::Vec2.new(SCREEN_WIDTH / 2 - 320, SCREEN_HEIGHT - 150)
  end
  
  def draw
    @image.draw position.x, position.y, ZOrder::Player, 1, 1
  end
  
end