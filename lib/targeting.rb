module Targeting
  
  # Returns the closest target in the fire arc.
  # TODO fire arc
  #
  def acquire *targets
    closest = nil
    lowest_distance = nil
    targets.each do |target|
      distance = (target.position - self.position).length
      next if lowest_distance && distance > lowest_distance
      lowest_distance = distance
      closest = target
    end
    return closest
  end
  
end