require_relative 'optParser'

module Rim
  # handle user key inputs
  # returns a lambda to run in another thread
  def self.main_handler
    return lambda {
      # ============== parse arguments ================
      begin
        optParser = Rim::Core.optParser
        optParser.parse!
        if not ARGV.empty?
          Rim::IO.file_arg = ARGV.shift
          Rim::IO.extra_args = ARGV
        end
        p Rim::IO.file_arg
        p Rim::IO.extra_args
      end
    }
  end
end
