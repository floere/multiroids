class FirstMate < Player
  
  include HorizonOriented
  acts_as_mothership
  with Torpedo, 10, 10
  
  lives 100
  
  def initialize window
    super window
    
    @image = Gosu::Image.new window, "media/first_mate.png", false
    @shape = CP::Shape::Circle.new CP::Body.new(1, 1), 5.0, CP::Vec2.new(0, 0)
    
    @shape.collision_type = :ship
    
    self.shoots Bullet
    self.muzzle_position_func { self.position + horizontal * 20 }
    self.muzzle_velocity_func { |target| horizontal }
    self.muzzle_rotation_func { self.rotation }
    self.frequency = 20
    
    self.rotation = 1.5*Math::PI
    self.acceleration = 0.10
    
    after_initialize
  end
  
end