class NukeLauncher < Cannon
  
  def initialize window
    super window
    
    self.frequency = 100
    self.range = 500
    self.muzzle_position_func { self.position }
    self.muzzle_velocity_func { |target| self.direction_from_earth }
    
    self.shoots Nuke
  end
  
end