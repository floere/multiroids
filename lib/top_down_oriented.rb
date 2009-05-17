module TopDownOriented
  
  def self.included target_class
    target_class.send :include, InstanceMethods
    target_class.extend IncludeMethods
  end
  
  module IncludeMethods
    
    def acceleration value
      class_inheritable_accessor :prototype_acceleration
      self.prototype_acceleration = value
      
      hook = lambda do
        self.acceleration = self.class.prototype_acceleration
      end
      InitializerHooks.register self, hook
    end
    
    def turning value
      class_inheritable_accessor :prototype_turning
      self.prototype_turning = value
      
      hook = lambda do
        self.turning = self.class.prototype_turning
      end
      InitializerHooks.register self, hook
    end
    
  end
  
  module InstanceMethods
    
    attr_accessor :acceleration
    attr_accessor :turning
    
    def full_speed_ahead factor = acceleration
      self.speed += rotation_vector * factor
    end
    def reverse factor = acceleration
      self.speed -= rotation_vector * factor * 0.1
    end
    def left amount = turning
      self.torque -= amount
    end
    def right amount = turning
      self.torque += amount
    end
    
  end
  
end