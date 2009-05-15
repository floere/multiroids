# "Threading"
# A hash with time => [block, block, block ...]
#
# {
#   100 => [{bla}, {blu}, {bli}],
#   1   => [{eek}]
# }
#
# When calling threading.step, eek will be executed, the others will be one step closer to zero, 99.
#
class Scheduling
  
  def initialize
    @threads = {}
  end
  
  def step
    new_threads = {}
    @threads.each_pair do |time, codes|
      time = time - 1
      if time <= 0
        execute codes
      else
        new_threads[time] = codes
      end
    end
    @threads = new_threads
  end
  
  def add time, code
    @threads[time] ||= []
    @threads[time] << code
  end
  
  def execute codes
    codes.each &:[]
  end
  
end