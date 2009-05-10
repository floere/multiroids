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
    self.caption = "MULTIROOOOIDS!"
    @background_image = Gosu::Image.new self, 'media/Space.png', true
    @beep = Gosu::Sample.new self, 'media/beep.wav'
    @score = 0
    @font = Gosu::Font.new self, Gosu::default_font_name, 20
    @moveables = []
    @controls = []
    @remove_shapes = []
    @dt = 1.0 / 60.0
  end
  
  def setup_space
    @space = CP::Space.new
    @space.damping = 0.8
  end
  
  def setup_objects
    register Earth.new(self)
    
    city = City.new self
    city.warp CP::Vec2.new(SCREEN_WIDTH/2, SCREEN_HEIGHT/2)
    city.put_on_surface
    register city
    
    nuke_gun = Gun.new self
    nuke_gun.warp CP::Vec2.new(100, 100)
    nuke_gun.put_on_surface -5
    nuke_gun.shoots Nuke
    register nuke_gun
    
    bullet_gun = Gun.new self
    bullet_gun.warp CP::Vec2.new(SCREEN_WIDTH-100, 100)
    bullet_gun.put_on_surface -5
    bullet_gun.shoots Bullet
    register bullet_gun
    
    add_player1
    add_player2
  end
  
  def setup_collisions
    @space.add_collision_func :city, :earth, &nil
    @space.add_collision_func :ship, :bullet do |ship_shape, bullet_shape|
      remove ship_shape
      remove bullet_shape
    end
    
    # @space.add_collision_func :bullet, :bullet do |bullet_shape1, bullet_shape2|
    #   remove bullet_shape1
    #   remove bullet_shape2
    # end
    
    @space.add_collision_func :ship, :earth do |ship_shape, earth_shape| end
    @space.add_collision_func :ship, :nuke do |ship_shape, nuke_shape|
      remove ship_shape
      remove nuke_shape
    end
    @space.add_collision_func :bullet, :nuke do |bullet_shape, nuke_shape|
      remove bullet_shape
      remove nuke_shape
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
    @player1.warp CP::Vec2.new(SCREEN_WIDTH/2, SCREEN_HEIGHT/2) # move to the center of the window
    # @player1.colorize 255, 0, 0
    
    @controls << Controls.new(self, @player1,
      Gosu::Button::KbLeft =>       :left,
      Gosu::Button::KbRight =>      :right,
      Gosu::Button::KbUp =>         :away,
      Gosu::Button::KbDown =>       :closer,
      Gosu::Button::KbSpace =>      :shoot
    )
    
    register @player1
  end
  
  # Adds the second player.
  #
  def add_player2
    @player2 = Player.new self
    # @player2.warp CP::Vec2.new(SCREEN_WIDTH-100, 20) # move to the center of the window
    # @player2.colorize 0, 255, 0
    # 
    # @controls << Controls.new(self, @player2,
    #   Gosu::Button::KbA =>           :turn_left,
    #   Gosu::Button::KbD =>           :turn_right,
    #   Gosu::Button::KbW =>           :accelerate,
    #   Gosu::Button::KbLeftControl => :boost,
    #   Gosu::Button::KbS =>           :reverse,
    #   Gosu::Button::KbLeftShift =>   :shoot
    # )
    # 
    # register @player2
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
      moveable.target @player1, @player2
    end
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
  end
  
  def draw_background
    @background_image.draw 0, 0, ZOrder::Background, 1.5, 1.2
  end
  
  def draw_moveables
    @moveables.each &:draw
  end
  
  def draw_ui
    # @font.draw "P1 Score: #{@player1.score}", 10, SCREEN_HEIGHT-30, ZOrder::UI, 1.0, 1.0, 0xffff0000
    # @font.draw "P2 Score: #{@player2.score}", SCREEN_WIDTH-110, 10, ZOrder::UI, 1.0, 1.0, 0xff00ff00
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