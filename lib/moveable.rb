# A moveable has a shape, speed etc.
#
class Moveable
  
  attr_reader :shape
  
  def initialize window, shape = nil
    @window = window
    @shape = shape if shape # refactoring
  end
  
  # Directly set the position of our Moveable.
  #
  def warp vect
    @shape.body.p = vect
  end
  
  # Directly set the position of our Moveable.
  #
  def position= position
    @shape.body.p = position
  end
  def position
    @shape.body.p
  end
  
  # Directly set the speed of our Moveable.
  #
  def speed= v
    @shape.body.v = v
  end
  def speed
    @shape.body.v
  end
  
  def current_speed
    Math.sqrt(speed.x**2 + speed.y**2)
  end
  
  # Directly set the rotation of our Moveable.
  #
  def rotation= rotation
    @shape.body.a = rotation
  end
  def rotation
    @shape.body.a
  end
  
  def drawing_rotation
    rotation.radians_to_gosu
  end
  
  # Some things you can only do every x seconds.
  #
  def sometimes variable, seconds, &block
    return unless instance_variable_get(:"@#{variable}")
    instance_variable_set :"@#{variable}", false
    result = block.call
    Thread.new do
      sleep seconds
      instance_variable_set :"@#{variable}", true
    end
    result
  end
  
  def rotation_vector
    @shape.body.a.radians_to_vec2
  end
  
  # Length is the vector length you want.
  #
  # Note: radians_to_vec2
  #
  def rotation_as_vector length
    rotation = -self.rotation + Math::PI / 2
    x = Math.sin rotation
    y = Math.cos rotation
    total_length = Math.sqrt(x**2 + y**2)
    multiplier = length / total_length
    CP::Vec2.new(x * multiplier, y * multiplier)
  end
  
  # Wrap to the other side of the screen when we fly off the edge.
  #
  def validate_position
    if position.x > SCREEN_WIDTH || position.x < 0
      @shape.body.v.x = -@shape.body.v.x
    end
    if position.y > SCREEN_HEIGHT || position.y < 0
      @shape.body.v.y = -@shape.body.v.y
    end
    # self.position = CP::Vec2.new(position.x % SCREEN_WIDTH, position.y % SCREEN_HEIGHT)
  end
  
  def add_to space
    space.add_body @shape.body
    space.add_shape @shape
  end
  
  def velocity
    @shape.body.v
  end
  
end