# A child can be attached to a mothership.
#
module Child
  
  attr_accessor :relative_child_position
  
  def update_relative mothership_position
    self.position = mothership_position + self.relative_child_position
  end
  
end