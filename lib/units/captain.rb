class Captain < Player
  
  include HorizonOriented
  
  lives 300
  
  def initialize window
    super window
    
    @image = Gosu::Image.new window, "media/captain.png", false
    
    body = CP::Body.new(10, 10)
    shape_array = [CP::Vec2.new(0, 0), CP::Vec2.new(87, 0), CP::Vec2.new(87, 22), CP::Vec2.new(0, 22)]
    @shape = CP::Shape::Poly.new body, shape_array, CP::Vec2.new(0, 0)
    
    @shape.collision_type = :ship
    
    self.shoots Bullet
    self.muzzle_position_func { self.position + horizontal * 40 }
    self.muzzle_velocity_func { |target| horizontal }
    self.muzzle_rotation_func { self.rotation }
    self.frequency = 20
    
    self.rotation = 1.5*Math::PI
    self.acceleration = 0.05
  end
  
end