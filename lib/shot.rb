module Shot
  
  attr_accessor :velocity, :lifetime
  
  def shoot_from shooter
    self.position = shooter.muzzle_position[]
    self.rotation = shooter.muzzle_rotation[]
    @window.register self
    Thread.new do
      sleep lifetime
      @window.unregister self
    end
    self
  end
  
end