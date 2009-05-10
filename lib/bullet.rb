#
class Bullet < Moveable
  
  include EarthOriented
  include Shot
  
  def initialize window
    super window
    
    @image = Gosu::Image.new window, "media/bullet.png", false
    
    @shape = CP::Shape::Circle.new(CP::Body.new(0.1, 0.1),
                                   1.0,
                                   CP::Vec2.new(0.0, 0.0))
    @shape.collision_type = :bullet
  end
  
  def self.shoot_from shooter
    bullet = new shooter.window
    bullet.shoot_from shooter
  end
  
  def validate_position
    closer
  end
  
  def draw
    @image.draw_rot(position.x, position.y, ZOrder::Player, drawing_rotation)
  end
  
end