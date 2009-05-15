module HorizonOriented
  
  def horizontal
    CP::Vec2.new(1,0)
  end
  def vertical
    CP::Vec2.new(0,1)
  end
  
  def left factor = 0.15
    self.speed -= horizontal * factor
  end
  def right factor = 0.15
    self.speed += horizontal * factor
  end
  def up factor = 0.15
    self.speed -= vertical * factor
  end
  def down factor = 0.15
    self.speed += vertical * factor
  end
  
end