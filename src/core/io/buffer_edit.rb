module Rim
  module Paint
    class Buffer
      def edit file, saved
        @file = file
        @file = File.absolute_path(file) if File.file?(@file)
        @saved = saved
        if File.file?(@file)
          content = File.read(@file)
          update_lines content
        end
        self
      end

      def insert char
        char = char.gsub("\r\n", "\n").gsub("\r", "\n").gsub("\t", " " * $tab_width)
        if char == "\n" || char == "\r"
          line = @lines[@row - 1]
          rest = line[@col..line.length]
          line[rest] = ''
          @lines.insert(@row, rest)
          @lines[@row - 1] = line
          @row += 1
          @col = 0
        else
          @lines[@row - 1].insert(@col, char)
          @col += 1
          @col += $tab_width - 1 if char == " " * $tab_width
        end
        @saved = false
        self
      end

      def backspace
        if @col > 0
          @lines[@row - 1].slice! @col - 1
          @col -= 1
        elsif @col == 0 and @row == 1
        else
          @col = @lines[@row - 2].length
          @lines[@row - 2].insert(@lines[@row - 2].length, @lines[@row - 1])
          @lines.delete_at(@row - 1)
          @row -= 1
        end
        @saved = false
        self
      end

      def delete
        if @col < @lines[@row-1].length
          @lines[@row - 1].slice! @col
        elsif @lines.length > @row
          @lines[@row].insert(@lines[@row].length, @lines[@row - 1])
          @lines.delete_at(@row - 1)
        end
        @saved = false
        self
      end
    end
  end
end
