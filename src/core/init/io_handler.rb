module Rim
  # handle user key inputs
  # returns a lambda to run in another thread
  def self.io_handler
    return lambda {
      until Rim.up;sleep 0.5;end
      loop do
      end
    }
  end
end
