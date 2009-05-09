# The Gosu::Window is always the "environment" of our game.
# It also provides the pulse of our game.
#
class GameWindow < Gosu::Window
  def initialize
    super SCREEN_WIDTH, SCREEN_HEIGHT, false, 16
    
    self.caption = "MULTIROOOOIDS!"
    
    @background_image = Gosu::Image.new self, 'media/Space.png', true

    # Put the beep here, as it is the environment now that determines collision
    @beep = Gosu::Sample.new self, 'media/Beep.wav'
    
    # Put the score here, as it is the environment that tracks this now
    @score = 0
    @font = Gosu::Font.new self, Gosu::default_font_name, 20
    
    # Time increment over which to apply a physics "step" ("delta t")
    @dt = 1.0 / 60.0
    
    # Create our Space and set its damping
    # A damping of 0.8 causes the ship bleed off its force and torque over time
    # This is not realistic behavior in a vacuum of space, but it gives the game
    # the feel I'd like in this situation
    @space = CP::Space.new
    # @space.damping = 0.8
    @space.damping = 1.0
    
    @player = Player.new self
    @player.add_to @space
    @player.warp CP::Vec2.new(320, 240) # move to the center of the window
    
    @asteroids = Array.new
    @bullets = Array.new
        
    # Here we define what is supposed to happen when a Player (ship) collides with a Star
    # I create a @remove_shapes array because we cannot remove either Shapes or Bodies
    # from Space within a collision closure, rather, we have to wait till the closure
    # is through executing, then we can remove the Shapes and Bodies
    # In this case, the Shapes and the Bodies they own are removed in the Gosu::Window.update phase
    # by iterating over the @remove_shapes array
    # Also note that both Shapes involved in the collision are passed into the closure
    # in the same order that their collision_types are defined in the add_collision_func call
    @remove_shapes = []
    @space.add_collision_func :ship, :asteroid do |ship_shape, asteroid_shape|
      @score += 10
      @beep.play
      # remove asteroid_shape
    end
    
    @space.add_collision_func :ship, :bullet do |ship_shape, bullet_shape|
      @score += 10
      @beep.play
      remove bullet_shape
    end
    
    # Here we tell Space that we don't want one star bumping into another
    # The reason we need to do this is because when the Player hits a Star,
    # the Star will travel until it is removed in the update cycle below
    # which means it may collide and therefore push other Stars
    #
    # To see the effect, remove this line and play the game, every once in a while
    # you'll see a Star moving
    @space.add_collision_func :asteroid, :asteroid, &nil
    
    @space.add_collision_func :bullet, :bullet do |bullet_shape1, bullet_shape2|
      remove bullet_shape1
      remove bullet_shape2
    end
  end
  
  def remove_collided
    # This iterator makes an assumption of one Shape per Star making it safe to remove
    # each Shape's Body as it comes up
    # If our Stars had multiple Shapes, as would be required if we were to meticulously
    # define their true boundaries, we couldn't do this as we would remove the Body
    # multiple times
    # We would probably solve this by creating a separate @remove_bodies array to remove the Bodies
    # of the Stars that were gathered by the Player
    #
    @remove_shapes.each do |shape|
      @asteroids.delete_if { |asteroid| asteroid.shape == shape }
      @space.remove_body shape.body
      @space.remove_shape shape
    end
    @remove_shapes.clear # clear out the shapes for next pass
  end
  
  def handle_input
    @player.turn_left if button_down? Gosu::Button::KbLeft
    @player.turn_right if button_down? Gosu::Button::KbRight
    
    if button_down? Gosu::Button::KbUp
      if ( (button_down? Gosu::Button::KbRightShift) || (button_down? Gosu::Button::KbLeftShift) )
        @player.boost
      else
        @player.accelerate
      end
    elsif button_down? Gosu::Button::KbDown
      @player.reverse
    end
    
    if button_down? Gosu::Button::KbSpace
      bullet = @player.shoot @space
      @bullets << bullet if bullet
    end
  end
  
  def reset_forces
    # When a force or torque is set on a Body, it is cumulative
    # This means that the force you applied last SUBSTEP will compound with the
    # force applied this SUBSTEP; which is probably not the behavior you want
    # We reset the forces on the Player each SUBSTEP for this reason
    #
    @player.shape.body.reset_forces
  end
  
  def wrap_around
    # Wrap around the screen to the other side
    @player.validate_position
  end
  
  def step_once
    # Perform the step over @dt period of time
    # For best performance @dt should remain consistent for the game
    @space.step @dt
  end
  
  def maybe_add_asteroid
    if @asteroids.size < 1 then
      asteroid = Asteroid.new self
      asteroid.add_to @space
      @asteroids.push asteroid
    end
  end
  
  def update
    # Step the physics environment SUBSTEPS times each update
    #
    SUBSTEPS.times do
      remove_collided
      reset_forces
      wrap_around
      handle_input
      step_once
    end
    maybe_add_asteroid
  end

  def draw
    @background_image.draw 0, 0, ZOrder::Background, 1.5, 1.2
    @player.draw
    @asteroids.each &:draw
    @bullets.each &:draw
    @font.draw "Score: #{@score}", 10, 10, ZOrder::UI, 1.0, 1.0, 0xffffff00
  end

  def button_down id
    close if id == Gosu::Button::KbEscape
  end
  
  def remove shape
    @remove_shapes << shape
  end
  
end