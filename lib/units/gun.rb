# This game will have multiple Players in the form of a ship.
#
class Gun < Moveable
  
  include EarthOriented
  include Targeting
  include Shooter
  
  def initialize window
    super window
    
    @bullet_loaded = true
    
    @image = Gosu::Image.new window, "media/gun.png", false
    
    @shape = CP::Shape::Circle.new CP::Body.new(1000.0, 75.0), 11.0, CP::Vec2.new(0, 0)
    @shape.collision_type = :gun
    
    skill = rand * 0.5
    
    self.shoots Bullet
    self.muzzle_position_func { self.position + self.direction_from_earth*10 }
    self.muzzle_velocity_func { |target| (target.position - self.muzzle_position[] + self.random_vector(1/skill)).normalize }
    self.muzzle_rotation_func { self.rotation }
    self.range = 300
    self.frequency = 30
  end
  
  def random_vector strength
    CP::Vec2.new(rand, rand).normalize! * strength
  end
  
  def target *targets
    target = acquire *targets
    shoot target
  end
  
  def validate_position
    align_to_earth
  end
  
  def draw
    @image.draw_rot self.position.x, self.position.y, ZOrder::Player, drawing_rotation
  end
end