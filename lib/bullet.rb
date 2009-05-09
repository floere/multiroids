#
class Bullet < Moveable
  
  def initialize window
    super window
    
    @speed = 40.0
    
    @image = Gosu::Image.new window, "media/bullet.png", false
    @shape = CP::Shape::Circle.new(CP::Body.new(0.1, 0.1),
                                   1.5,
                                   CP::Vec2.new(0.0, 0.0))
    @shape.collision_type = :circle
    
    # @shape.body.p = CP::Vec2.new(rand * SCREEN_WIDTH, rand * SCREEN_HEIGHT) # position
    @shape.body.v = CP::Vec2.new(rand(40) - 20, rand(40)-20) # velocity
    @shape.body.a = 3 * Math::PI / 2.0 # angle in radians; faces towards top of screen
    
    @shape.collision_type = :bullet
  end
  
  def shoot_from player
    self.position = player.position
    self.speed = player.rotation_as_vector @speed
    self.rotation = player.rotation
  end
  
  def draw
    @image.draw_rot(position.x, position.y, ZOrder::Player, drawing_rotation)
  end
  
end