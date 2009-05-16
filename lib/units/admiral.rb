class Admiral < Player
  
  acts_as_mothership
  with Gun, 130,   40
  with Gun, 130,  -40
  with Gun,  10,  140
  with Gun,  10, -140
  with Gun, 140,    0
  
  acceleration 0.0001
  turning      0.00001
  lives        300
  
  def initialize window
    super window
    
    @image = Gosu::Image.new window, "media/admiral.png", false
    @shape = CP::Shape::Circle.new CP::Body.new(100, 100), 100.0, CP::Vec2.new(0, 0)
    
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