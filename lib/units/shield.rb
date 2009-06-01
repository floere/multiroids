class Shield < Moveable
  
  include Lives
  lives 1000
  
  def initialize window
    super window
    
    @image = Gosu::Image.new window, "media/shield.png", false
    
    @shape = CP::Shape::Circle.new CP::Body.new(1000.0, 75.0), 1.0, CP::Vec2.new(0, 0)
    @shape.collision_type = :player
  end
  
  def draw
    @image.draw_rot self.position.x, self.position.y, ZOrder::Player, drawing_rotation
  end
end