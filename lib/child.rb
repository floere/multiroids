# A child can be attached to a mothership.
#
module Child
  
  attr_accessor :relative_child_position
  
  def update_relative mothership
    self.position = mothership.position + relative_child_position #mothership.rotation
    self.rotation = mothership.rotation
  end
  
end