class Admiral < Player
  
  acts_as_mothership
  with Gun, 0,  1 # center aft
  with Gun, 0, -2 # center steer
  with Gun, 3,  1 # front aft
  with Gun, 3, -1 # front steer
  with Gun, 5,  0 # front center
  
  acceleration 0.001
  turning      0.001
  lives          300
  
  def initialize window
    super window
    
    @image = Gosu::Image.new window, "media/admiral.png", false
    @shape = CP::Shape::Circle.new CP::Body.new(100_000, 100_000), 10.0, CP::Vec2.new(0, 0)
    
    # self.shoots Bullet
    # self.muzzle_position_func { self.position + horizontal * 140 }
    # self.muzzle_velocity_func { |target| horizontal }
    # self.muzzle_rotation_func { self.rotation }
    # self.frequency = 50
    
    @shape.collision_type = :ship
    
    # self.shoots Drone
    # self.muzzle_position_func { self.position + vertical * 100 }
    # self.muzzle_velocity_func { |target| horizontal }
    # self.muzzle_rotation_func { self.rotation }
    # self.frequency = 1000
    
    self.rotation = 0
    
    after_initialize
  end
  
  # def validate_position
  #   if self.lives < 300
  #     
  #   end
  # end
  
end