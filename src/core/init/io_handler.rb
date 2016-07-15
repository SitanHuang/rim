module Rim
  # handle user key inputs
  # returns a lambda to run in another thread
  class << self
    attr_accessor :last_key_status
  end
  @last_key_status = -1

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
        else
          @last_key_status = mode.handlers[:key].call mode, pane, ch
        end
        # @panes[Paint.focusedPane].buffer.lines[@panes[Paint.focusedPane].start_row] =
        # "#{@panes[Paint.focusedPane].buffer.row}"
        # @panes[Paint.focusedPane].draw! if @panes[Paint.focusedPane]
      end
    }
  end
end
