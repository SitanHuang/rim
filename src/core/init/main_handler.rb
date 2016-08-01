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

      sec_count = 0

      while Rim.up
        sleep 0.1
        if Rim::Paint.panes.empty?
          Rim.up = false
          $stdin.close
          Rim::Paint.refresh 100
          print T.cursor(1,1)
          return
        end
        if Paint.old_col != Paint.win_col or Paint.old_row != Paint.win_row or sec_count % 5 == 0
          Paint.onWindowResize
          system 'clear'
          Paint.paint
        end

        sec_count += 1
        sec_count = 0 if sec_count > 10
      end
    }
  end
end
