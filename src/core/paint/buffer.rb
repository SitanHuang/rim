module Rim
  module Paint
    class Buffer
      # the file that is editing, empty string for empty buffer
      attr_accessor :file
      attr_accessor :lines
      attr_accessor :row
      attr_accessor :col
      attr_accessor :saved

      def initialize file, content
        @row, @col = 1, 0
        @file = file
        # not saved when new file
        @saved = !@file.empty?
        # lines will be initialized in #update_lines
        update_lines content
      end

      # update lines in this buffer with a new content
      # warning, slow, need to update the whole thing
      def update_lines content
        # let all windows stuff into linux for better processing
        content = content.gsub("\r\n", "\n").gsub("\r", "\n").gsub("\t", " " * $tab_width) + "\n"
        # reset the lines in this buffer
        # or initialize when newed buffer
        @lines = []
        line = ""
        content.chars.each do |char|
          if char != "\n"
            line << char
          else
            # new line
            @lines << line
            line = ""
          end
        end
        self
      end

      def display_name
        if @file.empty?
          '[ New File ]'
        else
          @file + (@saved ? '' : '+')
        end
      end

      def cursor_row; row; end
      # cursor column in normal mode
      def cursor_col; col + 1; end
    end
  end
end
