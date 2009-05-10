module Accelerateable
  
  attr_accessor :top_speed, :acceleration
  
  def accelerate
    speed_diff = [self.top_speed - self.current_speed, 0].max
    acc = [self.acceleration, speed_diff].min
    @shape.body.apply_force((self.rotation_vector * (acc / SUBSTEPS)), CP::Vec2.new(0.0, 0.0))
  end
  
end