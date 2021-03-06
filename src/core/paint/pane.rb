require_relative 'buffer'
require_relative '../cmd'

module Rim
  module Paint
    class Pane
      include T

      # minimum width = 3
      attr_accessor :width
      # minimum height = 2
      attr_accessor :height

      # the col and row starts to paint
      # example: 1,1 not 0,0 because 0,0 is not paintable
      #          in a terminal
      attr_accessor :col
      attr_accessor :row

      # row and col to start paint
      attr_accessor :start_row
      attr_accessor :start_col
      attr_accessor :scroll_max_col

      attr_accessor :buffer
      attr_accessor :separator

      attr_accessor :focused

      attr_accessor :mode

      def initialize init
        @buffer = Buffer.new '', ""
        @separator = false
        @col = 1
        @row = 1
        @focused = true
        @start_row = 0
        @start_col = 0
        @scroll_max_col = @buffer.col
        @mode = NormalMode.new.name
        init.each_pair do |key, val|
          instance_variable_set '@' + key.to_s, val
        end
      end

      # calculate the last row of the pane
      def endRow; @row + @height - 1; end

      # calculate the last col of the pane
      def endCol; @col + @width - 1; end

      def moveRow rowChange
        buffer_size = @buffer.lines.size
        @buffer.row += rowChange
        @buffer.row = 1 if @buffer.row < 1
        @buffer.row = buffer_size if @buffer.row > buffer_size
        @buffer.col = @scroll_max_col
        if @buffer.col >= @buffer.lines[@buffer.row - 1].length
          @buffer.col = @buffer.lines[@buffer.row - 1].length - 1
        end
        @buffer.col = 0 if @buffer.col < 0
        calculateStartrow
        calculateStartcol
        self
      end

      def moveCol colChange
        @buffer.col += colChange
        if @buffer.col >= @buffer.lines[@buffer.row - 1].length
          if @buffer.lines[@buffer.row]
            @buffer.row += 1
            @buffer.col = 0
          else
            @buffer.col = @buffer.lines[@buffer.row - 1].length - 1
          end
        elsif @buffer.col < 0
          if @buffer.row - 1 > 0
            @buffer.row -= 1
            @buffer.col = @buffer.lines[@buffer.row - 1].length - 1
          else
            @buffer.col = 0
          end
        end
        @buffer.col = 0 if @buffer.col < 0
        @scroll_max_col = @buffer.col
        calculateStartrow
        calculateStartcol
        calculateStartrow
        calculateStartcol
        self
      end

      def scroll rowChange
        buffer_size = @buffer.lines.size
        @start_row += rowChange
        if @start_row >= buffer_size
          @start_row = buffer_size - 1
        elsif @start_row < 0
          @start_row = 0
        end
        @buffer.col = 0 if @buffer.col < 0
        self
      end

      def calculateStartrow
        if @start_row + @height - 1 < @buffer.row
          @start_row = @buffer.row - (@height - @height / 4)
        elsif @start_row >= @buffer.row
          @start_row = @buffer.row - (@height - @height / 4)
        end
        @start_row = 0 if @start_row < 0
        @buffer.col = 0 if @buffer.col < 0
        self
      end

      def sep_width
        separator ? 1 : 0
      end

      def calculateStartcol
        buffer_size = @buffer.lines.size
        max_line_length = 0
        max_line_length += $numbers_min_space + 1 if $numbers # spaces
        max_line_length += buffer_size.to_s.length if $numbers# numbers
        max_line_length = @width - max_line_length + sep_width
        if @start_col + max_line_length - 2\
            < @buffer.col
          @start_col +=5
        elsif @start_col > @buffer.col
          @start_col = @buffer.col - (@width - @width / 4)
        end
        @start_col = 0 if @start_col < 0
        @buffer.col = 0 if @buffer.col < 0
        self
      end

      # called from Paint#paint
      # not paint, not confusing anyone
      def draw
        calculateStartrow
        calculateStartcol

        theme_ui = Rim::Paint.theme[:ui]
        plain = Rim::Paint.theme[:plain]
        str = ''

        row = @row
        # lines array index in buffer
        line = @start_row
        buffer_size = @buffer.lines.size
        until row > endRow do
          str << T.default << theme_ui[:pane]
          # set the curser with the row
          str << T::cursor(row, @col)
          # fill gaps and reset for other
          # str << (@width < 5 ? '@' : ' ') * width
          str << ' ' * @width
          str << T::cursor(row, @col)
          # pane separator if
          str << theme_ui[:pane_sep] << theme_ui[:pane_sep_char]\
            << T.default if @separator

          # paint the content only if there's room
          if @width >= 5
            # if more line in buffer and
            # save space for the bottom status line
            if line < buffer_size && row < endRow
              # if line numbers enabled
              if $numbers
                display_line = (line + 1).to_s
                str << T.default << theme_ui[:pane_numbers]

                str << ' ' * ($numbers_min_space +
                      (buffer_size.to_s.length - display_line.length)) \
                      << display_line << ' ' # number and end space

                str << T.default
              end
              # == paint lines ==
              # calculate space left for content
              max_line_length = 0
              max_line_length += $numbers_min_space + 1 if $numbers # spaces
              max_line_length += buffer_size.to_s.length if $numbers# numbers
              max_line_length = @width - max_line_length + sep_width

              # we need :to_do syntax highlighting next
              # like add attributes at row:col in Buffer
              # process by colums
              str << plain[:line]
              str << plain[:current_line] if @buffer.row == line + 1
              # replace tabs with spaces virtually
              buffer_line = @buffer.lines[line][@start_col..10**10]
              if buffer_line == nil
                buffer_line = ''
              end
              buffer_line = buffer_line
              buffer_line[0..max_line_length].chars.each_with_index do |char, col|
                # insert syntax attributes here for a todo
                str << char
              end
              str << ' ' * (max_line_length - buffer_line.length) if buffer_line.size < max_line_length
            elsif row < endRow
              str << T.default << theme_ui[:pane]
              str << '~'
            elsif row == endRow
              str << Rim::Paint.theme[:status_line].call(self)
            end # line < buffer_size && row < endRow
          end # @width >= 5

          # next row
          row += 1
          line += 1
        end # until
        str << T.default
        if @focused && width >= 5
          # cursor row
          crow = @row + (@buffer.cursor_row - 1 - @start_row)
          ccol = @col - 1 + sep_width
          ccol += $numbers_min_space + buffer_size.to_s.length + 1 if $numbers
          ccol += @buffer.col + 1 - @start_col
          str << T.cursor(crow, ccol)
        elsif @focused && width < 5
          str << T.cursor(@row, @col)
        end
        return str
      end # draw

      def draw!; print draw; end

      # ===== pane configurations =====
      $numbers = true # line numbers
      $numbers_min_space = 1 # minimum space before number
      $tab_width = 4
      Cmd::COMMAND_HANDLERS['q'] = lambda { |force, trailing|
        raise RimError.new("Extra trailng args - #{trailng}") if trailing and trailing.length > 0
        pane = Rim::Paint.panes[Paint.focusedPane]
        sMode = pane.mode
        mode = Core.modes[sMode]
        mode.handlers[:exit].call mode, pane, force
      }

      Cmd::COMMAND_HANDLERS['w'] = lambda { |force, trailing|
        trailing.strip!
        pane = Rim::Paint.panes[Paint.focusedPane]
        content = pane.buffer.content
        file = pane.buffer.file
        if file.empty?
          file = trailing
          raise RimError.new("File name required") if trailing.empty?
          pane.buffer.file = file
        elsif !trailing.empty?
          raise RimError.new("Extra trailing args")
        end
        unless pane.buffer.saved
          File.write(file, content)
        end
        sizestr = "#{(content.bytesize / 1024.0).round(2)} KB"
        sizestr = "#{(content.bytesize / 1024.0 / 1024.0).round(2)} MB" if content.bytesize > 700
        pane.buffer.saved = true
        Rim::Paint.showMsg "#{sizestr} #{file}"
      }

      Cmd::COMMAND_HANDLERS['nu'] = Cmd::COMMAND_HANDLERS['number'] = lambda { |force, trailing|
        raise RimError.new("Extra trailng args - #{trailng}") if trailing and trailing.length > 0
        $numbers = !force
      }

      Cmd::COMMAND_HANDLERS['tabw'] = Cmd::COMMAND_HANDLERS['tw'] = Cmd::COMMAND_HANDLERS['tabwidth'] = lambda { |force, trailing|
        raise RimError.new("Require trailng args") if !trailing or trailing.empty?
        $tab_width = trailing.strip.to_i
        pane = Rim::Paint.panes[Paint.focusedPane]
        pane.buffer.lines.each_with_index do |line, index|
          pane.buffer.lines[index] = line.sub(/^ +/, " " * $tab_width)
        end
        pane.moveCol(-1).moveCol(1).moveRow 0
      }
    end
  end
end
