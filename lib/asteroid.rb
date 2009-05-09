class Asteroid < Moveable
  
  def initialize window
    super window
    
    @image = Gosu::Image.new window, "media/asteroid.png", false
    
    # @color = Gosu::Color.new 0xff000000
    # @color.red = rand(255 - 40) + 40
    # @color.green = rand(255 - 40) + 40
    # @color.blue = rand(255 - 40) + 40
    
    body = CP::Body.new 10, 150
    @shape = CP::Shape::Circle.new(body, 60, CP::Vec2.new(0.0, 0.0))
    @shape.body.p = CP::Vec2.new(rand * SCREEN_WIDTH, -30) # position
    @shape.body.v = CP::Vec2.new(0, rand(20)) # velocity
    @shape.body.a = 3 * Math::PI / 2.0 # angle in radians; faces towards top of screen
    
    @shape.collision_type = :asteroid
  end

  def draw
    @image.draw(@shape.body.p.x - @image.width / 2.0, @shape.body.p.y - @image.height / 2.0, ZOrder::Stars, 1, 1)
  end
  
end