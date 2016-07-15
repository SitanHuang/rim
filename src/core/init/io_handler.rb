module Rim
  # handle user key inputs
  # returns a lambda to run in another thread
  def self.io_handler
    return lambda {
      until Rim.up;sleep 0.1;end
      # testing
      while Rim.up
        ch = read_char
        case ch
          # when "\e[A"
          #   @panes[Paint.focusedPane].moveRow(-1)
          # when "\e[1;3A"
          #   @panes[Paint.focusedPane].scroll(-2).moveRow(-2)
          # when "\e[B"
          #   @panes[Paint.focusedPane].moveRow(1)
          # when "\e[1;3B"
          #   @panes[Paint.focusedPane].scroll(2).moveRow(2)
          # when "\e[D"
          #   @panes[Paint.focusedPane].moveCol(-1)
          # when "\e[C"
          #   @panes[Paint.focusedPane].moveCol(1)
          # when "s"
          #   @panes[Paint.focusedPane].separator = !@panes[Paint.focusedPane].separator
          # when ":"
          #   print T.cursor(Paint.win_row, 1) + "\n:"
          #   begin
          #     p "=> #{eval gets}"
          #   rescue => error
          #     puts error
          #   end
          #   puts "\nPress ENTER to continue"
          #   gets
          when "q"
            pane = Rim::Paint.panes[Paint.focusedPane]
            Rim::Core.modes[pane.mode].handlers[:exit].call pane
        end
        # @panes[Paint.focusedPane].buffer.lines[@panes[Paint.focusedPane].start_row] =
        # "#{@panes[Paint.focusedPane].buffer.row}"
        # @panes[Paint.focusedPane].draw! if @panes[Paint.focusedPane]
      end
    }
  end
end
