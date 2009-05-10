module Targetable
  
  def distance_from shooter
    (self.position - shooter.position).length
  end
  
end