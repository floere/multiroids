# A thing is destroyed if a number of lives has been passed.
#
module Lives
  
  def self.included target_class
    target_class.extend IncludeMethods
  end
  
  module IncludeMethods
    
    def lives amount
      include InstanceMethods
      class_inheritable_accessor :prototype_lives
      self.prototype_lives = amount
      
      hook = lambda { self.lives = self.class.prototype_lives }
      InitializerHooks.register self, hook
    end
    
  end
  
  module InstanceMethods
    
    attr_accessor :lives
    
    def hit!
      self.lives -= 1
      destroy if self.lives <= 0
    end
    
  end
  
end

# module Lives
#   
#   def lives= lives
#     @lives = lives
#   end
#   
#   def hit!
#     @lives -= 1
#     @score -= 1 if @score
#     destroy if @lives <= 0
#   end
#   
# end