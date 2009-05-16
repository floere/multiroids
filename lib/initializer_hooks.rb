# def initialize
#   after_initialize
# end
# 
module InitializerHooks
  
  mattr_accessor :hooks # { class => [blocks] }
  self.hooks = {}
  
  def after_initialize
    hooks = InitializerHooks.hooks[self.class]
    hooks && hooks.each do |hook|
      self.instance_eval &hook
    end
  end
  
  def self.register klass, hook
    self.hooks[klass] ||= []
    self.hooks[klass] << hook
  end
  
end