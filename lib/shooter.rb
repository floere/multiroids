module Shooter
  
  def shoots type
    @shot_type = type
  end
  
  def shot
    @shot_type.new @window
  end
  
end