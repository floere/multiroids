# A moveable has a shape, speed etc.
#
class Moveable
  
  attr_reader :shape
  
  def initialize window, shape = nil
    @window = window
    @shape = shape if shape # refactoring
  end
  
  # Directly set the position of our Moveable.
  def warp vect
    @shape.body.p = vect
  end
  
  def point_to radian
    @shape.body.a = radian
  end
  
  def direction
    @shape.body.a
  end
  
  # Wrap to the other side of the screen when we fly off the edge.
  #
  def validate_position
    l_position = CP::Vec2.new(@shape.body.p.x % SCREEN_WIDTH, @shape.body.p.y % SCREEN_HEIGHT)
    @shape.body.p = l_position
  end
  
  def add_to space
    space.add_body @shape.body
    space.add_shape @shape
  end
  
  def position
    @shape.body.p
  end
  
  def velocity
    @shape.body.v
  end
  
end