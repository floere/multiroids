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
    
    @shape = CP::Shape::Circle.new CP::Body.new(10.0, 75.0), 11.0, CP::Vec2.new(0, 0)
    
    @shape.collision_type = :gun
    
    self.shoots Bullet
  end
  
  def random_vector strength
    CP::Vec2.new(rand, rand).normalize! * strength
  end
  
  def muzzle_position
    self.position
  end
  def muzzle_velocity target
    (target.position - self.position).normalize * 80 + random_vector(20)
  end
  def muzzle_rotation
    self.rotation
  end
  def shot_lifetime
    3
  end
  def target *targets
    target = acquire *targets
    shoot target
  end
  def shoot? target
    target.distance_from(self) < 300
  end
  def shoot target
    return unless shoot? target
    sometimes :bullet_loaded, 1.0 do
      bullet = self.shot.shoot_from self
      bullet.speed = self.muzzle_velocity target
    end
  end
  
  def validate_position
    align_to_earth
  end
  
  def draw
    @image.draw_rot self.position.x, self.position.y, ZOrder::Player, drawing_rotation
  end
end