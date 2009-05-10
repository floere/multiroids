# This game will have multiple Players in the form of a ship.
#
class Player < Moveable
  
  include EarthOriented
  include Targeting
  
  def initialize window
    super window
    
    @bullet_loaded = true
    
    @image = Gosu::Image.new window, "media/gun.png", false
    
    @shape = CP::Shape::Circle.new CP::Body.new(10.0, 75.0), 11.0, CP::Vec2.new(0, 0)
    
    @shape.collision_type = :gun
  end
  
  def muzzle_position
    
  end
  
  def target *targets
    target = acquire *targets
    shoot
  end
  
  def shoot
    sometimes :bullet_loaded, 0.2 do
      Bullet.shoot_from self
    end
  end
  
  def validate_position
    align_to_earth
  end
  
  def draw
    @image.draw_rot self.position.x, self.position.y, ZOrder::Player, drawing_rotation
  end
end