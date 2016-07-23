module Rim
  # handle user key inputs
  # returns a lambda to run in another thread
  class << self
    attr_accessor :last_key_status
    attr_accessor :last_key
  end
  @last_key_status = -1
  @last_key = ''

  def self.io_handler
    return lambda {
      until Rim.up;sleep 0.1;end
      # testing
      while Rim.up
        ch = read_char
        pane = Rim::Paint.panes[Paint.focusedPane]
        sMode = pane.mode
        mode = Core.modes[sMode]

        if ch == "\e"
          mode.handlers[:exit].call mode, pane
          @last_key_status = 1
        elsif ch == "\x1c"
          Process.kill 9, Process.pid
        else
          @last_key = ch
          @last_key_status = mode.handlers[:key].call mode, pane, ch
        end
      end
    }
  end
end
