module Shot
  
  attr_accessor :velocity, :lifetime, :originator
  
  def shoot_from shooter
    self.position = shooter.muzzle_position[]
    self.rotation = shooter.muzzle_rotation[]
    self.originator = shooter
    @window.register self
    threaded do
      sleep lifetime
      @window.unregister self
    end
    self
  end
  
end