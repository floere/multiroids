module EarthOriented
  
  def direction_to_earth
    self.position - EARTH_POSITION
  end
  
  def attach_to_earth
    align_to_earth
    put_on_surface
  end
  
  def put_anywhere
    
  end
  
  def put_on_surface difference = 0.0
    self.position = EARTH_POSITION + (self.direction_to_earth.normalize * (EARTH_RADIUS + difference))
  end
  
  def align_to_earth
    self.rotation = self.direction_to_earth.to_angle
  end
  
  def left
    direction = self.direction_to_earth.normalize
    direction.x, direction.y = direction.y, -direction.x
    self.position += direction * 0.1
  end
  
  def right
    direction = self.direction_to_earth.normalize
    direction.x, direction.y = -direction.y, direction.x
    self.position += direction * 0.1
  end
  
  def away
    self.position += self.direction_to_earth.normalize * 0.1
  end
  
  def closer
    self.position -= self.direction_to_earth.normalize * 0.1
  end
  
end