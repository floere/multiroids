# A mothership just has a number of gun batteries or hangars or whatever.
#
module MotherShip
  
  def self.included target_class
    target_class.extend ClassMethods
  end
  
  module ClassMethods
    
    def acts_as_mothership
      include InstanceMethods
      alias_method_chain :validate_position, :children
    end
    
  end
  
  module InstanceMethods
    
    attr_accessor :children
    
    def add_child child, x, y
      self.children ||= []
      child.extend Child
      window.register child
      child.relative_child_position = CP::Vec2.new(x, y)
      self.children << child
    end
    
    def update_children
      self.children.each { |child| child.update_relative self.position }
    end
    
    def validate_position_with_children
      update_children
      validate_position_without_children
    end
    
  end
  
end