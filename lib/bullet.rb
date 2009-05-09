#
class Bullet < Moveable
  
  def initialize window
    super window
    
    @image = Gosu::Image.new window, "media/bullet.png", false
    
    body = CP::Body.new(0.0001, 0.0001)
    @shape = CP::Shape::Circle.new(body, 3, CP::Vec2.new(0.0, 0.0))
    @shape.collision_type = :circle
    @shape.body.p = CP::Vec2.new(rand * SCREEN_WIDTH, rand * SCREEN_HEIGHT) # position
    @shape.body.v = CP::Vec2.new(rand(40) - 20, rand(40)-20) # velocity
    @shape.body.a = 3 * Math::PI / 2.0 # angle in radians; faces towards top of screen
  end
  
  def draw
    @image.draw_rot(@shape.body.p.x, @shape.body.p.y, ZOrder::Player, @shape.body.a.radians_to_gosu)
  end
  
end