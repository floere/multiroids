# This game will have multiple Players in the form of a ship.
#
class Gun < Moveable
  
  include Targeting
  include Shooter
  
  def initialize window
    super window
    
    @bullet_loaded = true
    
    @image = Gosu::Image.new window, "media/gun.png", false
    
    @shape = CP::Shape::Circle.new CP::Body.new(1000.0, 75.0), 3.0, CP::Vec2.new(0, 0)
    @shape.collision_type = :gun
    
    skill = rand * 0.1
    
    self.shoots Bullet
    self.muzzle_position_func { self.position }
    self.muzzle_velocity_func { |target| (target.position - self.muzzle_position[] + self.random_vector(1/skill)).normalize }
    self.muzzle_rotation_func { |target| (target.position - self.muzzle_position[]).to_angle }
    self.range = 900
    self.frequency = 300
  end
  
  def random_vector strength
    CP::Vec2.new(rand, rand).normalize! * strength
  end
  
  def target *targets
    return if targets.empty?
    target = acquire *targets
    shoot target
  end
  
  
  def draw
    @image.draw_rot self.position.x, self.position.y, ZOrder::Player, drawing_rotation
  end
end