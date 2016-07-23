module Rim
  module Paint
    class Split
      VSPLIT = 1
      HSPLIT = 2
      NSPLIT = 3 # no split

      attr_accessor :type
      attr_accessor :pane # if no split, the only pane

      attr_accessor :split1
      attr_accessor :split2

      def initialize pane=nil
        @pane = pane
      end

      def col
        return @pane.col if @type == NSPLIT
        return @split1.col
      end

      def row
        return @pane.row if @type == NSPLIT
        return @split1.row
      end

      def endCol
        return @pane.endCol if @type == NSPLIT
        return @split2.endCol
      end

      def endRow
        return @pane.endRow if @type == NSPLIT
        return @split2.endRow
      end

    end
  end
end
