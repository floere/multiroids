# This game will have multiple Players in the form of a ship.
#
class Player < Moveable
  
  include EarthOriented
  include Targetable
  include Shooter
  
  attr_reader :score
  
  def initialize window
    super window
    
    @score = 0
    
    @bullet_loaded = true
    
    @image = Gosu::Image.new window, "media/spaceship.png", false
    
    @shape = CP::Shape::Circle.new CP::Body.new(10.0, 75.0), 11.0, CP::Vec2.new(0, 0)
    
    # up-/downgradeable
    # self.turn_speed     = 0.1
    # self.acceleration   = 150.0
    # self.top_speed      = 200.0
    
    self.friction       = 1.0
    
    @deceleration       = 200.0
    
    # Keep in mind that down the screen is positive y, which means that PI/2 radians,
    # which you might consider the top in the traditional Trig unit circle sense is actually
    # the bottom; thus 3PI/2 is the top
    self.rotation = Math::PI
    
    @shape.collision_type = :ship
    
    self.shoots Bullet
  end
  
  def muzzle_position
    self.position + self.direction_to_earth * 20
  end
  def muzzle_velocity
    self.direction_to_earth
  end
  def muzzle_rotation
    self.rotation
  end
  def shot_lifetime
    4
  end
  
  def score!
    @score += 10
  end
  
  def colorize red, green, blue
    @color.red = red
    @color.green = green
    @color.blue = blue
  end
  
  # Apply reverse force
  # See accelerate for more details
  #
  def reverse
    deceleration = [@deceleration, (@top_speed-self.current_speed)].min
    @shape.body.apply_force(-(rotation_vector * (deceleration / SUBSTEPS)), CP::Vec2.new(0.0, 0.0))
  end
  
  def shoot
    sometimes :bullet_loaded, 0.5 do
      self.shot.shoot_from self
    end
  end
  
  # Wrap to the other side of the screen when we fly off the edge.
  #
  def validate_position
    align_to_earth
    if position.x > SCREEN_WIDTH || position.x < 0
      @shape.body.v.x = -@shape.body.v.x
    end
    if position.y > SCREEN_HEIGHT || position.y < 0
      @shape.body.v.y = -@shape.body.v.y
    end
  end
  
  def draw
    @image.draw_rot self.position.x, self.position.y, ZOrder::Player, drawing_rotation
  end
end