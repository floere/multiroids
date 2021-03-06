# This game will have multiple Players in the form of a ship.
#
class Player < Moveable
  
  include Targetable
  include Shooter
  include Lives
  include TopDownOriented
  include MotherShip # just adds the ability
  
  attr_accessor :score
  
  def initialize window, color = 0x99ff0000
    super window
    
    @font = window.font
    @color = color
    
    @score = 0
    @projectile_loaded = true
    
    @image = Gosu::Image.new window, "media/spaceship.png", false
    @shape = CP::Shape::Circle.new CP::Body.new(0.1, 0.1), 5.0, CP::Vec2.new(0, 0)
    
    self.friction = 1.0
    self.rotation = -Math::PI
    
    @shape.collision_type = :ship
    
    self.shoots Projectile
    self.muzzle_position_func { self.position + self.direction_to_earth * 20 }
    self.muzzle_velocity_func { |target| self.direction_to_earth }
    self.muzzle_rotation_func { self.rotation }
    self.frequency = 20
  end
  
  def revive
    window.revive self
  end
  
  def colorize red, green, blue
    @color.red = red
    @color.green = green
    @color.blue = blue
  end
  
  # Wrap to the other side of the screen when we fly off the edge.
  #
  def validate_position
    if position.x > SCREEN_WIDTH || position.x < 0
      @shape.body.v.x = -@shape.body.v.x
    end
    if position.y > SCREEN_HEIGHT || position.y < 0
      @shape.body.v.y = -@shape.body.v.y
    end
  end
  
  def draw
    @font.draw "P1 Score: #{score}", 10, 10, ZOrder::UI, 1.0, 1.0, @color
    @font.draw "#{torque.round}", position.x - 10, position.y + 10, ZOrder::UI, 0.5, 0.5, @color
    @font.draw "#{speed.length.round}", position.x + 10, position.y + 10, ZOrder::UI, 0.5, 0.5, @color
    @image.draw_rot position.x, position.y, ZOrder::Player, drawing_rotation
  end
end