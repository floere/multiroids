#
class Bullet < Moveable
  
  def initialize window
    super window
    
    @image = Gosu::Image.new window, "media/bullet.png", false
    @shape = CP::Shape::Circle.new(CP::Body.new(0.0001, 0.0001),
                                   1.5,
                                   CP::Vec2.new(0.0, 0.0))
    @shape.collision_type = :circle
    
    # @shape.body.p = CP::Vec2.new(rand * SCREEN_WIDTH, rand * SCREEN_HEIGHT) # position
    @shape.body.v = CP::Vec2.new(rand(40) - 20, rand(40)-20) # velocity
    @shape.body.a = 3 * Math::PI / 2.0 # angle in radians; faces towards top of screen
  end
  
  def shoot_from player
    self.position = player.position
    self.speed = player.speed * 2
    self.rotation = player.rotation
  end
  
  def draw
    @image.draw_rot(position.x, position.y, ZOrder::Player, drawing_rotation)
  end
  
end