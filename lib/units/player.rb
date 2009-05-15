# This game will have multiple Players in the form of a ship.
#
class Player < Moveable
  
  include Targetable
  include Shooter
  include Lives
  include MotherShip # just adds the ability
  
  attr_accessor :score
  
  def initialize window
    super window
    
    @score = 0
    
    @bullet_loaded = true
    
    @image = Gosu::Image.new window, "media/spaceship.png", false
    
    @shape = CP::Shape::Circle.new CP::Body.new(0.1, 0.1), 5.0, CP::Vec2.new(0, 0)
    
    self.friction       = 1.0
    
    @deceleration       = 300.0
    
    self.rotation = -Math::PI
    
    @shape.collision_type = :ship
    
    self.shoots Bullet
    self.muzzle_position_func { self.position + self.direction_to_earth * 20 }
    self.muzzle_velocity_func { |target| self.direction_to_earth }
    self.muzzle_rotation_func { self.rotation }
    self.frequency = 20
    
    self.lives = 30
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
    @image.draw_rot position.x, position.y, ZOrder::Player, drawing_rotation
  end
end