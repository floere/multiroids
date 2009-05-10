# This game will have multiple Players in the form of a ship.
#
class Nuke < Moveable
  
  include TargetAcquisition
  
  attr_reader :score
  
  def initialize window
    super window
    
    body = CP::Body.new 10.0, 75.0
    
    shape_array = [CP::Vec2.new(-10.0, -10.0), CP::Vec2.new(-10.0, 10.0), CP::Vec2.new(10.0, 1.0), CP::Vec2.new(10.0, -1.0)]
    @shape = CP::Shape::Poly.new body, shape_array, CP::Vec2.new(0,0)
    
    @image = Gosu::Image.new window, "media/nuke.png", false
    
    # up-/downgradeable
    @rotation           = 0.1
    @acceleration       = 0.1
    @deceleration       = 0.1
    @top_speed          = 3
    
    self.rotation = -2*Math::PI/3
    
    @shape.collision_type = :nuke
  end
  
  # TODO extract into module
  #
  def target *targets
    target = acquire *targets
    follow target
  end
  
  # Tries to hit the target.
  #
  def follow target
    direct = target.position - self.position
    angle = (self.rotation - direct.to_angle) % (Math::PI*2)
    
    case angle
    when 0..Math::PI : turn_left
    when Math::PI..(2*Math::PI) : turn_right
    end
    
    case angle + Math::PI/2
    when 0..Math::PI : accelerate
    when Math::PI..(2*Math::PI) : reverse
    end
  end
  
  def turn_left
    self.rotation -= @rotation / SUBSTEPS
  end
  def turn_right
    self.rotation += @rotation / SUBSTEPS
  end
  def accelerate
    acceleration = [@acceleration, (@top_speed - self.current_speed)].min
    @shape.body.apply_force((rotation_vector * (acceleration / SUBSTEPS)), CP::Vec2.new(0.0, 0.0))
  end
  def reverse
    deceleration = [@deceleration, (@top_speed - self.current_speed)].min
    @shape.body.apply_force(-(rotation_vector * (deceleration / SUBSTEPS)), CP::Vec2.new(0.0, 0.0))
  end
  
  def draw
    @image.draw_rot position.x, position.y, ZOrder::Player, drawing_rotation, 1.0, 1.0, 1.0, 1.0
  end
end