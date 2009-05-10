class ShortLived < Moveable
  
  class_inheritable_accessor :lifetime
  
  def initialize window
    super window
    
    threaded do
      sleep self.lifetime
      window.unregister self
    end
  end
  
  def lifetime= duration
    @lifetime = duration
  end
  def lifetime
    @lifetime
  end
  
end