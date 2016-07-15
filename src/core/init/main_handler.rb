require_relative 'optParser'
require_relative '../pane_management'

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
      rescue StandardError => e
        puts "#{e}"
        exit 1
      end

      begin
        # ============== open editor ===============
        edit "#{Rim::IO.file_arg}"
        Paint.init
      rescue RimError => e
        puts e
        puts "Press ENTER to continue."
        STDIN.readline
      end

      Rim.up = true

      while Rim.up
        sleep 0.1
        if Rim::Paint.panes.empty?
          Rim.up = false
          $stdin.close
        end
      end
    }
  end
end
