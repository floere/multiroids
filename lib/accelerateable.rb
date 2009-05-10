module Accelerateable
  
  attr_accessor :top_speed, :acceleration
  
  def accelerate
    # diff = (self.rotation_vector.normalize * self.top_speed) - self.speed
    # 
    # part = [diff.length / 2 - self.top_speed, 0].max
    # 
    # puts part
    # 
    # acc = self.acceleration * part
    
    @shape.body.apply_force((self.rotation_vector * (self.acceleration / SUBSTEPS)), CP::Vec2.new(0.0, 0.0))
  end
  
end