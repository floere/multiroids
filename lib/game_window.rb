# The Gosu::Window is always the "environment" of our game.
# It also provides the pulse of our game.
#
class GameWindow < Gosu::Window
  
  attr_reader :space, :font
  
  def initialize
    # set to true for fullscreen
    super SCREEN_WIDTH, SCREEN_HEIGHT, true, 16
    
    init
    setup_space
    setup_objects
    setup_collisions
  end
  
  def init
    self.caption = "Incredible space battles!"
    @background_image = Gosu::Image.new self, 'media/Space.png', true
    @beep = Gosu::Sample.new self, 'media/beep.wav'
    @score = 0
    @font = Gosu::Font.new self, Gosu::default_font_name, 20
    @moveables = []
    @controls = []
    @remove_shapes = []
    @players = []
    @waves = Waves.new self
    @scheduling = Scheduling.new
    @step = 0
    @dt = 1.0 / 60.0
  end
  
  def setup_space
    @space = CP::Space.new
    @space.damping = 1.0 # no damping
  end
  
  def threaded time, code
    @scheduling.add time, code
  end
  
  def randomly_add type
    thing = type.new self
    
    thing.warp_to SCREEN_WIDTH, rand*SCREEN_HEIGHT
    
    register thing
  end
  
  def setup_objects
    wave 10, Enemy,  100
    wave 10, Enemy,  400
    wave 10, Enemy,  700
    wave 10, Enemy, 1000
    
    add_admiral
    add_captain
    add_first_mate
  end
  
  def wave amount, type, time
    @waves.add amount, type, time
  end
  
  def small_explosion shape
    explosion = SmallExplosion.new self
    explosion.warp shape.body.p
    remove shape
    register explosion
  end
  
  def setup_collisions
    @space.add_collision_func :projectile, :projectile, &nil
    @space.add_collision_func :projectile, :gun, &nil
    @space.add_collision_func :projectile, :explosion, &nil
    @space.add_collision_func :projectile, :ambient, &nil
    @space.add_collision_func :projectile, :enemy do |projectile_shape, enemy_shape|
      @moveables.each { |projectile| projectile.shape == projectile_shape && projectile.destroy }
    end
    @space.add_collision_func :enemy, :explosion do |enemy_shape, explosion_shape|
      @moveables.each { |enemy| enemy.shape == enemy_shape && enemy.lives -= 100 }
    end
    
    @space.add_collision_func :ship, :projectile, &nil
    @space.add_collision_func :ship, :gun, &nil
    @space.add_collision_func :ship, :nuke do |ship_shape, nuke_shape|
      small_explosion nuke_shape
    end
    @space.add_collision_func :ship, :ambient do |_, _|
      # just push it away
    end
    @space.add_collision_func :ship, :enemy do |_, _|
      # just push it away
    end
    
    @space.add_collision_func :nuke, :ambient, &nil
    
    @space.add_collision_func :gun, :nuke, &nil
    
    @space.add_collision_func :projectile, :nuke do |projectile_shape, nuke_shape|
      small_explosion projectile_shape
      remove nuke_shape
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
  def add_admiral
    @player1 = Cruiser.new self, 0x99ff0000
    @player1.warp_to 400, 320
    
    @controls << Controls.new(self, @player1,
      Gosu::Button::KbA => :left,
      Gosu::Button::KbD => :right,
      Gosu::Button::KbW => :full_speed_ahead,
      Gosu::Button::KbS => :reverse,
      Gosu::Button::Kb1 => :revive
    )
    
    @players << @player1
    
    register @player1
  end
  
  # Adds the second player.
  #
  def add_captain
    @player2 = Cruiser.new self, 0x9900ff00
    @player2.warp_to 400, 250
    
    @controls << Controls.new(self, @player2,
      Gosu::Button::KbH => :left,
      Gosu::Button::KbK => :right,
      Gosu::Button::KbU => :full_speed_ahead,
      Gosu::Button::KbJ => :reverse,
      Gosu::Button::Kb7 => :revive
    )
    
    @players << @player2
    
    register @player2
  end
  
  # Adds the third player.
  #
  def add_first_mate
    @player3 = Cruiser.new self, 0x990000ff
    @player3.warp_to 400, 400
    
    @controls << Controls.new(self, @player3,
      Gosu::Button::KbLeft =>  :left,
      Gosu::Button::KbRight => :right,
      Gosu::Button::KbUp =>    :full_speed_ahead,
      Gosu::Button::KbDown =>  :reverse,
      Gosu::Button::Kb0 =>     :revive
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
    @moveables.select { |m| m.respond_to? :target }.each do |gun|
      gun.target *@moveables.select { |m| m.kind_of? Enemy }
    end
  end
  
  def revive player
    return if @moveables.find { |moveable| moveable == player }
    register player
  end
  
  #
  #
  def update
    @step += 1
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
    @waves.check @step
    @scheduling.step
  end
  
  def draw_background
    @background_image.draw 0, 0, ZOrder::Background, 1.5, 1.2
  end
  
  def draw_moveables
    @moveables.each &:draw
  end
  
  def draw_ui
    # @font.draw "P1 Score: #{@player1.score}", 10, 10, ZOrder::UI, 1.0, 1.0, 0xffff0000
    # @font.draw "#{@player1.torque.round}", @player1.position.x - 10, @player1.position.y + 10, ZOrder::UI, 0.5, 0.5, 0x99ff0000
    # @font.draw "#{@player1.speed.length.round}", @player1.position.x + 10, @player1.position.y + 10, ZOrder::UI, 0.5, 0.5, 0x99ff0000
    # 
    # @font.draw "P2 Score: #{@player2.score}", SCREEN_WIDTH/2-50, 10, ZOrder::UI, 1.0, 1.0, 0xff00ff00
    # @font.draw "#{@player2.torque.round}", @player2.position.x - 10, @player2.position.y + 10, ZOrder::UI, 0.5, 0.5, 0x9900ff00
    # @font.draw "#{@player2.speed.length.round}", @player2.position.x + 10, @player2.position.y + 10, ZOrder::UI, 0.5, 0.5, 0x9900ff00
    # 
    # @font.draw "P3 Score: #{@player3.score}", SCREEN_WIDTH-110, 10, ZOrder::UI, 1.0, 1.0, 0xff0000ff
    # @font.draw "#{@player3.torque.round}", @player3.position.x - 10, @player3.position.y + 10, ZOrder::UI, 0.5, 0.5, 0x990000ff
    # @font.draw "#{@player3.speed.length.round}", @player3.position.x + 10, @player3.position.y + 10, ZOrder::UI, 0.5, 0.5, 0x990000ff
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