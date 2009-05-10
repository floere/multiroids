class ShortLived < Moveable
  
  class_inheritable_accessor :lifetime
  
  def initialize window
    super window
    
    Thread.new do
      sleep self.lifetime
      window.unregister self
    end
  end
  
  def lifetime
    self.class.lifetime
  end
  
end