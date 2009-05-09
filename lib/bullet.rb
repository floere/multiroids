#
class Bullet < Moveable
  
  def initialize window, shape
    super window, shape
    
    @image = Gosu::Image.new window, "media/bullet.png", false
  end
  
  def draw
    @image.draw_rot(@shape.body.p.x, @shape.body.p.y, ZOrder::Player, @shape.body.a.radians_to_gosu)
  end
  
end