class NukeLauncher < Gun
  
  def initialize window
    super window
    
    self.frequency = 0.3
    self.range = 500
    self.muzzle_velocity_func { |target| self.direction_from_earth }
  end
  
end