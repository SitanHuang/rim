require_relative 'buffer.rb'

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

      attr_accessor :buffer
      attr_accessor :separator

      def initialize init
        @buffer = Buffer.new '', ''
        @separator = false
        @col = 1
        @row = 1
        init.each_pair do |key, val|
          instance_variable_set '@' + key.to_s, val
        end
      end

      # calculate the last row of the pane
      def endRow; @row + @height - 1; end

      # calculate the last col of the pane
      def endCol; @col + @width - 1; end

      # called from Paint#paint
      def draw
        theme_ui = Rim::Paint.theme[:ui]
        str = T.default + theme_ui[:pane]

        row = @row
        # lines array index in buffer
        line = 0
        until row > endRow do
          # set the curser with the row
          str << T::cursor(row, @col)
          # fill gaps
          str << ' ' * width
          str << T::cursor(row, @col)
          # pane separator if
          str << theme_ui[:pane_sep] << theme_ui[:pane_sep_char]\
            << T.default << theme_ui[:pane] if @separator

          # next row
          row += 1
          line += 1
        end
        str << T.default
        return str
      end

      # ===== pane configurations =====
      $pane_numbers = true
    end
  end
end
