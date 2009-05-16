class Thing
  
  include InitializerHooks
  
  attr_reader :window, :shape
  
  def initialize window
    @running_threads = []
    @window = window
  end
  
  def threaded time, &code
    window.threaded time, code
  end
  
  def destroy
    @window.unregister self
    @running_threads.select { |thread| thread.status == false }.each(&:join)
    true
  end
  
  # Some things you can only do every x units.
  #
  def sometimes variable, units = 1, &block
    name = :"@#{variable}"
    return if instance_variable_get(name)
    instance_variable_set name, true
    result = block.call
    threaded units do
      self.instance_variable_set name, false
    end
    result
  end
  
  def add_to space
    space.add_body @shape.body
    space.add_shape @shape
  end
  
  class << self
    def it_is *traits
      traits.each { |trait| include trait }
    end
    alias it_is_a it_is
  end
  
end