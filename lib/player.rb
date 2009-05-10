# This game will have multiple Players in the form of a ship.
#
class Player < Moveable
  
  include Turnable
  include Accelerateable
  
  attr_reader :score
  
  def initialize window
    super window
    
    @score = 0
    
    @boost_enabled = true
    @bullet_loaded = true
    
    @color = Gosu::Color.new 0xff000000
    
    body = CP::Body.new 10.0, 75.0
    
    shape_array = [CP::Vec2.new(-10.0, -10.0), CP::Vec2.new(-10.0, 10.0), CP::Vec2.new(10.0, 1.0), CP::Vec2.new(10.0, -1.0)]
    @shape = CP::Shape::Poly.new body, shape_array, CP::Vec2.new(0,0)
    
    @image = Gosu::Image.new window, "media/spaceship.png", false
    
    # up-/downgradeable
    self.turn_speed     = 0.1
    self.acceleration   = 800.0
    self.top_speed      = 200.0
    
    @boost_acceleration = 100_000.0
    @deceleration       = 200.0
    
    # Keep in mind that down the screen is positive y, which means that PI/2 radians,
    # which you might consider the top in the traditional Trig unit circle sense is actually
    # the bottom; thus 3PI/2 is the top
    direction = 3 * Math::PI / 2.0
    
    @shape.collision_type = :ship
  end
  
  def score!
    @score += 10
  end
  
  def colorize red, green, blue
    @color.red = red
    @color.green = green
    @color.blue = blue
  end
  
  # Apply even more forward force.
  # See accelerate for more details.
  #
  def boost
    sometimes :boost_enabled, 5 do
      @shape.body.apply_force((rotation_vector * (@boost_acceleration / SUBSTEPS)), CP::Vec2.new(0.0, 0.0))
    end
  end
  
  # Apply reverse force
  # See accelerate for more details
  #
  def reverse
    deceleration = [@deceleration, (@top_speed-self.current_speed)].min
    @shape.body.apply_force(-(rotation_vector * (deceleration / SUBSTEPS)), CP::Vec2.new(0.0, 0.0))
  end
  
  def shoot
    sometimes :bullet_loaded, 0.2 do
      bullet = Bullet.new @window
      bullet.shoot_from self
      bullet.add_to @window.space
      bullet
    end
  end
  
  def draw
    @image.draw_rot(@shape.body.p.x, @shape.body.p.y, ZOrder::Player, drawing_rotation, 1.0, 1.0, 1.0, 1.0, @color)
  end
end