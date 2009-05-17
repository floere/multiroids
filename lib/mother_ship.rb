# A mothership just has a number of gun batteries or hangars or whatever.
#
module MotherShip
  
  def self.included target_class
    target_class.extend IncludeMethods
  end
  
  module IncludeMethods
    
    def acts_as_mothership
      include InstanceMethods
      alias_method_chain :validate_position, :children
      
      class_inheritable_accessor :prototype_children
      extend ClassMethods
      hook = lambda do
        self.class.prototype_children.each do |type, x, y|
          add_child type.new(window), x, y
        end
      end
      InitializerHooks.register self, hook
    end
    
  end
  
  module ClassMethods
    
    def with type, x, y
      self.prototype_children ||= []
      self.prototype_children << [type, x, y]
    end
    
  end
  
  module InstanceMethods
    
    attr_accessor :children
    
    def add_child child, x, y
      self.children ||= []
      child.extend Child
      window.register child
      child.rotation = self.rotation
      child.relative_child_position = CP::Vec2.new(x, y)
      self.children << child
    end
    
    def update_children
      self.children.each do |child|
        child.update_relative self
      end
    end
    
    def validate_position_with_children
      update_children
      validate_position_without_children
    end
    
  end
  
end