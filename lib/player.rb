# This game will have multiple Players in the form of a ship.
#
class Player < Moveable
  
  include EarthOriented
  include Targetable
  include Shooter
  include Lives
  
  attr_reader :score
  
  def initialize window
    super window
    
    @score = 0
    
    @bullet_loaded = true
    
    @image = Gosu::Image::load_tiles window, "media/spaceship.png", 22, 22, false
    
    @shape = CP::Shape::Circle.new CP::Body.new(0.1, 0.1), 11.0, CP::Vec2.new(0, 0)
    
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
    self.muzzle_position_func { self.position + self.direction_to_earth * 20 }
    self.muzzle_velocity_func { |target| self.direction_to_earth }
    self.muzzle_rotation_func { self.rotation }
    self.frequency = 2
    
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
    align_to_earth
    if position.x > SCREEN_WIDTH || position.x < 0
      @shape.body.v.x = -@shape.body.v.x
    end
    if position.y > SCREEN_HEIGHT || position.y < 0
      @shape.body.v.y = -@shape.body.v.y
    end
  end
  
  def draw
    image = @image[Gosu::milliseconds / 100 % @image.size];
    image.draw_rot self.position.x, self.position.y, ZOrder::Player, drawing_rotation
  end
end