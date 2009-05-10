module Generator
  
  def self.included base
    base.extend ClassMethods
  end
  
  module ClassMethods
    
    def generates moveable_class, seconds
      self.send :include, InstanceMethods
      @@generates_moveable_class = moveable_class
      @@generates_moveable_class_every_seconds = seconds
    end
    
  end
  
  module InstanceMethods
    
    def start_generating
      # TODO join this thread on generator death
      threaded do
        loop do
          sleep 1
          generate
        end
      end
    end
    
    def generate
      generated = Puff.new self.window # @@generates_moveable_class.new self.window
      generated.warp self.position
      self.window.register generated
    end
    
  end
  
end