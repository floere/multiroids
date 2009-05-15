module HorizonOriented
  
  def acceleration= acceleration
    @acceleration = acceleration
  end
  def acceleration
    @acceleration || 0.15
  end
  
  def horizontal
    CP::Vec2.new(1,0)
  end
  def vertical
    CP::Vec2.new(0,1)
  end
  
  def left factor = acceleration
    self.speed -= horizontal * factor
  end
  def right factor = acceleration
    self.speed += horizontal * factor
  end
  def up factor = acceleration
    self.speed -= vertical * factor
  end
  def down factor = acceleration
    self.speed += vertical * factor
  end
  
end