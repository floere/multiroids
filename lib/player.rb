# This game will have multiple Players in the form of a ship.
#
class Player < Moveable
  
  def initialize window
    super window
    
    @bullet_loaded = true
    
    # Create the Body for the Player
    body = CP::Body.new 10.0, 150.0
    
    # In order to create a shape, we must first define it
    # Chipmunk defines 3 types of Shapes: Segments, Circles and Polys
    # We'll use s simple, 4 sided Poly for our Player (ship)
    # You need to define the vectors so that the "top" of the Shape is towards 0 radians (the right)
    #
    shape_array = [CP::Vec2.new(-10.0, -10.0), CP::Vec2.new(-10.0, 10.0), CP::Vec2.new(10.0, 1.0), CP::Vec2.new(10.0, -1.0)]
    @shape = CP::Shape::Poly.new body, shape_array, CP::Vec2.new(0,0)
    
    # The collision_type of a shape allows us to set up special collision behavior
    # based on these types.  The actual value for the collision_type is arbitrary
    # and, as long as it is consistent, will work for us; of course, it helps to have it make sense
    @shape.collision_type = :ship
    
    @image = Gosu::Image.new window, "media/spaceship.png", false
    
    @shape.body.p = CP::Vec2.new 0.0, 0.0 # position
    @shape.body.v = CP::Vec2.new 0.0, 0.0 # velocity
    
    @rotation           = 250.0 # up-/downgradeable
    @acceleration       = 800.0 # up-/downgradeable
    @boost_acceleration = 800.0 # up-/downgradeable
    @deceleration       = 200.0 # up-/downgradeable
    
    # Keep in mind that down the screen is positive y, which means that PI/2 radians,
    # which you might consider the top in the traditional Trig unit circle sense is actually
    # the bottom; thus 3PI/2 is the top
    direction = 3 * Math::PI / 2.0
    # @shape.body.a =  3 * Math::PI / 2.0 # angle in radians; faces towards top of screen
  end
  
  # Apply negative Torque; Chipmunk will do the rest
  # SUBSTEPS is used as a divisor to keep turning rate constant
  # even if the number of steps per update are adjusted
  #
  def turn_left
    @shape.body.t -= @rotation / SUBSTEPS
  end
  
  # Apply positive Torque; Chipmunk will do the rest
  # SUBSTEPS is used as a divisor to keep turning rate constant
  # even if the number of steps per update are adjusted
  #
  def turn_right
    @shape.body.t += @rotation / SUBSTEPS
  end
  
  # Apply forward force; Chipmunk will do the rest
  # SUBSTEPS is used as a divisor to keep acceleration rate constant
  # even if the number of steps per update are adjusted
  # Here we must convert the angle (facing) of the body into
  # forward momentum by creating a vector in the direction of the facing
  # and with a magnitude representing the force we want to apply.
  #
  def accelerate
    @shape.body.apply_force((@shape.body.a.radians_to_vec2 * (@acceleration/SUBSTEPS)), CP::Vec2.new(0.0, 0.0))
  end
  
  # Apply even more forward force.
  # See accelerate for more details.
  #
  def boost
    @shape.body.apply_force((@shape.body.a.radians_to_vec2 * ((@acceleration + @boost_acceleration)/SUBSTEPS)), CP::Vec2.new(0.0, 0.0))
  end
  
  # Apply reverse force
  # See accelerate for more details
  #
  def reverse
    @shape.body.apply_force(-(@shape.body.a.radians_to_vec2 * (@deceleration/SUBSTEPS)), CP::Vec2.new(0.0, 0.0))
  end
  
  def shoot?
    @bullet_loaded
  end
  
  def shoot space
    return unless shoot?
    bullet = Bullet.new @window
    bullet.shoot_from self
    bullet.add_to space
    bullet
  end
  
  def draw
    @image.draw_rot(@shape.body.p.x, @shape.body.p.y, ZOrder::Player, drawing_rotation)
  end
end