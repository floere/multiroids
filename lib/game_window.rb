# The Gosu::Window is always the "environment" of our game.
# It also provides the pulse of our game.
#
class GameWindow < Gosu::Window
  
  attr_reader :space
  
  def initialize
    super SCREEN_WIDTH, SCREEN_HEIGHT, false, 16
    
    init
    setup_space
    setup_objects
    setup_collisions
  end
  
  def init
    self.caption = "Aliens attaaaaack!"
    @background_image = Gosu::Image.new self, 'media/Space.png', true
    @beep = Gosu::Sample.new self, 'media/beep.wav'
    @score = 0
    @font = Gosu::Font.new self, Gosu::default_font_name, 20
    @moveables = []
    @controls = []
    @remove_shapes = []
    @players = []
    @scheduling = Scheduling.new
    @dt = 1.0 / 60.0
  end
  
  def setup_space
    @space = CP::Space.new
    @space.damping = 0.8
  end
  
  def threaded time, code
    @scheduling.add time, code
  end
  
  def randomly_add type
    thing = type.new self
    
    thing.warp_to rand*SCREEN_WIDTH, rand*SCREEN_HEIGHT
    
    thing.put_on_surface
    register thing
  end
  
  def setup_objects
    # register Earth.new(self)
    # 
    # 7.times { randomly_add Cow }
    # 2.times { randomly_add NukeLauncher }
    # 3.times { randomly_add Gun }
    
    add_player1
    add_player2
    add_player3
  end
  
  def small_explosion shape
    explosion = SmallExplosion.new self
    explosion.warp shape.body.p
    remove shape
    register explosion
  end
  
  def setup_collisions
    @space.add_collision_func :ship, :ambient do |ship_shape, ambient_shape|
      # just push it away
    end
    @space.add_collision_func :nuke, :ambient, &nil
    @space.add_collision_func :bullet, :ambient, &nil
    
    @space.add_collision_func :city, :earth, &nil
    
    @space.add_collision_func :ship, :earth do |ship_shape, earth_shape| end
    @space.add_collision_func :ship, :nuke do |ship_shape, nuke_shape|
      small_explosion nuke_shape
    end
    
    @space.add_collision_func :ray, :cow do |_, cow_shape|
      @moveables.each { |cow| cow.shape == cow_shape && cow.away(10) }
    end
    @space.add_collision_func :ship, :cow do |ship_shape, cow_shape|
      @moveables.each { |ship| ship.shape == ship_shape && ship.score += 10 }
      remove cow_shape
    end
    
    @space.add_collision_func :gun, :nuke, &nil
    
    @space.add_collision_func :bullet, :nuke do |bullet_shape, nuke_shape|
      small_explosion bullet_shape
      remove nuke_shape
    end
    @space.add_collision_func :bullet, :ship do |bullet_shape, ship_shape|
      small_explosion bullet_shape
    end
    @space.add_collision_func :bullet, :city do |bullet_shape, ship_shape|
      small_explosion bullet_shape
    end
    @space.add_collision_func :bullet, :earth do |bullet_shape, earth_shape|
      remove bullet_shape
    end
    
    @space.add_collision_func :city, :explosion do |city_shape, explosion_shape|
      @moveables.each { |city| city.shape == city_shape && city.hit! }
    end
    @space.add_collision_func :ship, :explosion do |ship_shape, explosion_shape|
      @players.each { |player| player.shape == ship_shape && player.hit! }
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
  #         threaded do
  #           5.times { sleep 0.1; animate_explosion }
  #           @window.unregister self
  #         end
  #       end
  #
  def unregister moveable
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
    @player1 = Admiral.new self
    @player1.warp_to 150, 400 # move to the center of the window
    
    @controls << Controls.new(self, @player1,
      Gosu::Button::KbA =>           :left,
      Gosu::Button::KbD =>           :right,
      Gosu::Button::KbW =>           :up,
      Gosu::Button::KbS =>           :down,
      Gosu::Button::KbLeftShift =>   :shoot,
      Gosu::Button::Kb1 =>           :revive
    )
    
    @players << @player1
    
    register @player1
  end
  
  # Adds the second player.
  #
  def add_player2
    @player2 = Captain.new self
    @player2.warp_to 100, SCREEN_HEIGHT - 150
    
    @controls << Controls.new(self, @player2,
      Gosu::Button::KbH =>     :left,
      Gosu::Button::KbK =>     :right,
      Gosu::Button::KbU =>     :up,
      Gosu::Button::KbJ =>     :down,
      Gosu::Button::KbSpace => :shoot,
      Gosu::Button::Kb7 =>     :revive
    )
    
    @players << @player2
    
    register @player2
  end
  
  # Adds the third player.
  #
  def add_player3
    @player3 = FirstMate.new self
    @player3.warp_to 50, 100 # move to the center of the window
    
    @controls << Controls.new(self, @player3,
      Gosu::Button::KbLeft =>       :left,
      Gosu::Button::KbRight =>      :right,
      Gosu::Button::KbUp =>         :up,
      Gosu::Button::KbDown =>       :down,
      Gosu::Button::KbRightAlt =>   :shoot,
      Gosu::Button::Kb0 =>          :revive
    )
    
    @players << @player3
    
    register @player3
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
      @space.remove_body shape.body
      @space.remove_shape shape
      @moveables.delete_if { |moveable| moveable.shape == shape && moveable.destroy }
    end
    @remove_shapes.clear
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
    # @player1.shape.body.reset_forces
    # @player2.shape.body.reset_forces
    # @player3.shape.body.reset_forces
    # @players.each { |player| player.shape.body.reset_forces }
  end
  
  # Checks whether
  #
  def validate
    @moveables.each &:validate_position
  end
  
  def step_once
    # Perform the step over @dt period of time
    # For best performance @dt should remain consistent for the game
    @space.step @dt
  end
  
  def targeting
    @moveables.select { |m| m.respond_to? :target }.each do |moveable|
      moveable.target @player1, @player2, @player3
    end
  end
  
  def revive player
    return if @moveables.find { |moveable| moveable == player }
    register player
  end
  
  #
  #
  def update
    # Step the physics environment SUBSTEPS times each update.
    #
    SUBSTEPS.times do
      remove_collided
      reset_forces
      validate
      targeting
      handle_input
      step_once
    end
    @scheduling.step
  end
  
  def draw_background
    @background_image.draw 0, 0, ZOrder::Background, 1.5, 1.2
  end
  
  def draw_moveables
    @moveables.each &:draw
  end
  
  def draw_ui
    @font.draw "P1 Score: #{@player1.score}", 10, 10, ZOrder::UI, 1.0, 1.0, 0xffff0000
    @font.draw "P2 Score: #{@player2.score}", SCREEN_WIDTH/2-50, 10, ZOrder::UI, 1.0, 1.0, 0xff00ff00
    @font.draw "P3 Score: #{@player3.score}", SCREEN_WIDTH-110, 10, ZOrder::UI, 1.0, 1.0, 0xff0000ff
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