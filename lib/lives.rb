module Lives
  
  def lives= lives
    @lives = lives
  end
  
  def hit!
    @lives -= 1
    @score -= 1
    destroy if @lives <= 0
  end
  
end