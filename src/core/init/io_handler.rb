module Rim
  # handle user key inputs
  # returns a lambda to run in another thread
  def self.io_handler
    return lambda {
      loop do
        if Rim.up

        end
      end
    }
  end
end
