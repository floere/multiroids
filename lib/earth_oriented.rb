module EarthOriented
  
  def direction_to_earth
    (EARTH_POSITION - self.position).normalize!
  end
  
  def direction_from_earth
    (self.position - EARTH_POSITION).normalize!
  end
  
  def attach_to_earth
    align_to_earth
    put_on_surface
  end
  
  def put_anywhere
    
  end
  
  def put_on_surface difference = 0.0
    self.position = EARTH_POSITION + (direction_from_earth * (EARTH_RADIUS + difference))
  end
  
  def align_to_earth
    self.rotation = direction_from_earth.to_angle
  end
  
  def left
    direction = direction_from_earth
    direction.x, direction.y = direction.y, -direction.x
    self.position += direction * 0.1
  end
  
  def right
    direction = direction_from_earth
    direction.x, direction.y = -direction.y, direction.x
    self.position += direction * 0.1
  end
  
  def away
    self.position += direction_from_earth * 0.1
  end
  
  def closer
    self.position += direction_to_earth * 0.1
  end
  
end