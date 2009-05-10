module Turnable
  
  attr_accessor :turn_speed
  
  def turn_left
    self.rotation -= self.turn_speed / SUBSTEPS
  end
  def turn_right
    self.rotation += self.turn_speed / SUBSTEPS
  end
  
end