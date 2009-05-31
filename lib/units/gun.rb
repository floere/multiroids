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
    
    skill = 0.05 + rand * 0.5
    
    self.shoots Bullet
    self.muzzle_position_func { self.position }
    self.muzzle_velocity_func { |target| (target.position - self.muzzle_position[] + self.random_vector(1/skill)).normalize }
    self.muzzle_rotation_func { |target| (target.position - self.muzzle_position[]).to_angle }
    self.range = 600
    self.frequency = 8
    
    # Metaprog this
    # @sound = Gosu::Sample.new window, 'media/sounds/cannon_shot.mp3'
    
    salvo!
  end
  
  def random_vector strength
    CP::Vec2.new(rand-0.5, rand-0.5).normalize! * strength
  end
  
  def target *targets
    return unless @salvoing
    return if targets.empty?
    target = acquire *targets
    shoot target
  end
  
  def salvo!
    @salvoing = true
    threaded 30 do salvo_over end
  end
  
  def salvo_over
    @salvoing = false
    threaded 150 do salvo! end
  end
  
  def draw
    @image.draw_rot self.position.x, self.position.y, ZOrder::Player, drawing_rotation
  end
end