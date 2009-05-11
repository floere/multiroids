# A moveable has a shape, speed etc.
#
class Moveable
  
  attr_reader :window, :shape
  
  def initialize window
    @running_threads = []
    @window = window
  end
  
  def destroy
    @window.unregister self
    @running_threads.select { |thread| thread.status == false }.each(&:join)
    true
  end
  
  def threaded time, &code
    # @running_threads << Thread.new(&block)
    window.threaded time, code
  end
  
  # Directly set the position of our Moveable using a vector.
  #
  def warp vector
    @shape.body.p = vector
  end
  
  # Directly set the position of our Moveable.
  #
  def warp_to x, y
    @shape.body.p = CP::Vec2.new(x, y)
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
    self.rotation.radians_to_gosu
  end
  
  def friction= friction
    @shape.u = friction
  end
  def friction
    @shape.u
  end
  
  # Some things you can only do every x units.
  #
  def sometimes variable, units = 1, &block
    name = :"@#{variable}"
    return if instance_variable_get(name)
    instance_variable_set name, true
    result = block.call
    threaded units do
      self.instance_variable_set name, false
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
    
  end
  
  def add_to space
    space.add_body @shape.body
    space.add_shape @shape
  end
  
  def velocity
    @shape.body.v
  end
  
end