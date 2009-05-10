# The Gosu::Window is always the "environment" of our game.
# It also provides the pulse of our game.
#
class GameWindow < Gosu::Window
  
  attr_reader :space
  
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
    @space.damping = 0.97
    
    # Replace these with moveables.
    #
    # @asteroids = []
    # @bullets = []
    
    @moveables = []
    
    @controls = []
    
    add_player1
    add_player2
    
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
      
    end
    
    @space.add_collision_func :ship, :bullet, &nil
    
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
  
  # Moveables register themselves here.
  #
  def register moveable
    @moveables << moveable
    moveable.add_to @space
  end
  
  # Moveables unregister themselves here.
  #
  # Note: Use as follows in a Moveable.
  #       
  #       def destroy
  #         Thread.new do
  #           5.times { sleep 0.1; animate_explosion }
  #           @window.unregister self
  #         end
  #       end
  #
  def unregister moveable
    @moveables.delete moveable # FIXME Make threadable.
    remove moveable.shape
  end
  
  # Remove this shape the next turn.
  #
  # Note: Internal use. Use unregister to properly remove a moveable.
  #
  def remove shape
    @remove_shapes << shape
  end
  
  # Adds the first player.
  #
  def add_player1
    @player1 = Player.new self
    # @player1.add_to @space
    @player1.warp CP::Vec2.new(SCREEN_WIDTH/2, SCREEN_HEIGHT-20) # move to the center of the window
    @player1.colorize 255, 0, 0
    
    @controls << Controls.new(self, @player1,
      Gosu::Button::KbLeft =>       :turn_left,
      Gosu::Button::KbRight =>      :turn_right,
      Gosu::Button::KbUp =>         :accelerate,
      Gosu::Button::KbRightShift => :boost,
      Gosu::Button::KbDown =>       :reverse,
      Gosu::Button::KbSpace =>      :shoot
    )
    
    register @player1
  end
  
  # Adds the second player.
  #
  def add_player2
    @player2 = Player.new self
    # @player2.add_to @space
    @player2.warp CP::Vec2.new(SCREEN_WIDTH/2, 20) # move to the center of the window
    @player2.colorize 0, 255, 0
    
    @controls << Controls.new(self, @player2,
      Gosu::Button::KbA =>           :turn_left,
      Gosu::Button::KbD =>           :turn_right,
      Gosu::Button::KbW =>           :accelerate,
      Gosu::Button::KbLeftControl => :boost,
      Gosu::Button::KbS =>           :reverse,
      Gosu::Button::KbLeftShift =>   :shoot
    )
    
    register @player2
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
      @moveables.delete_if { |moveable| moveable.shape == shape }
      # @asteroids.delete_if { |asteroid| asteroid.shape == shape }
      @space.remove_body shape.body
      @space.remove_shape shape
    end
    @remove_shapes.clear # clear out the shapes for next pass
  end
  
  def handle_input
    @controls.each &:handle
  end
  
  def reset_forces
    # When a force or torque is set on a Body, it is cumulative
    # This means that the force you applied last SUBSTEP will compound with the
    # force applied this SUBSTEP; which is probably not the behavior you want
    # We reset the forces on the Player each SUBSTEP for this reason
    #
    @player1.shape.body.reset_forces
    @player2.shape.body.reset_forces
  end
  
  def wrap_around
    # Wrap around the screen to the other side
    @player1.validate_position
    @player2.validate_position
  end
  
  def step_once
    # Perform the step over @dt period of time
    # For best performance @dt should remain consistent for the game
    @space.step @dt
  end
  
  # TODO refactor
  #
  def check_score
    remove = []
    @moveables.each do |moveable|
      if moveable.respond_to?(:scoring?) && moveable.scoring?
        @player1.score! if moveable.top_goal?
        @player2.score! if moveable.bottom_goal?
        remove << moveable
      end
    end
    remove.each do |moveable|
      @remove_shapes << moveable.shape
      @moveables.delete moveable
    end
  end
  
  #
  #
  def maybe_add_asteroid
    register Asteroid.new(self) if @moveables.size < 3
  end
  
  #
  #
  def update
    # Step the physics environment SUBSTEPS times each update.
    #
    SUBSTEPS.times do
      remove_collided
      reset_forces
      wrap_around
      handle_input
      step_once
    end
    check_score
    maybe_add_asteroid
  end
  
  def draw_background
    @background_image.draw 0, 0, ZOrder::Background, 1.5, 1.2
  end
  
  def draw_moveables
    @moveables.each &:draw
  end
  
  def draw_ui
    @font.draw "P1 Score: #{@player1.score}", 10, SCREEN_HEIGHT-30, ZOrder::UI, 1.0, 1.0, 0xffff0000
    @font.draw "P2 Score: #{@player2.score}", SCREEN_WIDTH-110, 10, ZOrder::UI, 1.0, 1.0, 0xff00ff00    
  end
  
  def draw
    draw_background
    draw_moveables
    draw_ui
  end
  
  # Escape exits.
  #
  def button_down id
    close if id == Gosu::Button::KbEscape
  end
  
end