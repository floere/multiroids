class Admiral < Player
  
  include HorizonOriented
  
  def initialize window
    super window
    
    @image = Gosu::Image.new window, "media/admiral.png", false
    @shape = CP::Shape::Circle.new CP::Body.new(100, 100), 100.0, CP::Vec2.new(0, 0)
    
    self.shoots Bullet
    self.muzzle_position_func { self.position + vertical * 100 }
    self.muzzle_velocity_func { |target| horizontal }
    self.muzzle_rotation_func { self.rotation }
    self.frequency = 50
    
    # self.shoots Drone
    # self.muzzle_position_func { self.position + vertical * 100 }
    # self.muzzle_velocity_func { |target| horizontal }
    # self.muzzle_rotation_func { self.rotation }
    # self.frequency = 1000
    
    self.rotation = 1.5*Math::PI
    self.acceleration = 0.05
  end
  
end