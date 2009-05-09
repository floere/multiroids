class Asteroid < Moveable
  
  def initialize window
    super window
    
    @image = Gosu::Image.new window, "media/asteroid.png", false
    
    @color = Gosu::Color.new 0xff000000
    @color.red = rand(255 - 40) + 40
    @color.green = rand(255 - 40) + 40
    @color.blue = rand(255 - 40) + 40
    
    body = CP::Body.new(0.0001, 0.0001)
    @shape = CP::Shape::Circle.new(body, 25/2, CP::Vec2.new(0.0, 0.0))
    @shape.collision_type = :star
    @shape.body.p = CP::Vec2.new(rand * SCREEN_WIDTH, rand * SCREEN_HEIGHT) # position
    @shape.body.v = CP::Vec2.new(rand(40) - 20, rand(40)-20) # velocity
    @shape.body.a = 3 * Math::PI / 2.0 # angle in radians; faces towards top of screen
  end

  def draw
    @image.draw(@shape.body.p.x - @image.width / 2.0, @shape.body.p.y - @image.height / 2.0, ZOrder::Stars, 1, 1, @color, :additive)
  end
  
end