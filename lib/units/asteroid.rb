class Asteroid < Moveable
  
  attr_reader :points
  
  def initialize window
    super window
    
    @points = 0
    @image = Gosu::Image.new window, "media/asteroid.png", false
    
    body = CP::Body.new 10, 150
    @shape = CP::Shape::Circle.new(body, 60, CP::Vec2.new(0.0, 0.0))
    x = rand < 0.5 ? 0 : 1
    self.position = CP::Vec2.new(x*SCREEN_WIDTH, SCREEN_HEIGHT/2) # position
    dirx = x.zero? ? 1 : -1
    self.speed = CP::Vec2.new(dirx*rand(40), 0) # velocity
    self.rotation = 3 * Math::PI / 2.0 # angle in radians; faces towards top of screen
    
    @shape.collision_type = :asteroid
  end
  
  def scoring?
    y = self.position.y
    y > SCREEN_HEIGHT || y < 0
  end
  
  def top_goal?
    self.position.y < 0
  end
  
  def bottom_goal?
    self.position.y > SCREEN_HEIGHT
  end
  
  def draw
    @image.draw(@shape.body.p.x - @image.width / 2.0, @shape.body.p.y - @image.height / 2.0, ZOrder::Stars, 1, 1)
  end
  
end