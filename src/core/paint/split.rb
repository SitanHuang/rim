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

      def initialize pane
        @pane = pane
        @type = NSPLIT
      end

      def resize rowChange, colChange
        if @type == NSPLIT
          @pane.width += colChange
          @pane.height += rowChange
        end
        # TODO
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

      def toPanes
        return [] if @type == NSPLIT && pane == nil
        return [@pane] if @type == NSPLIT
        array = []
        array += @split1.toPanes + @split2.toPanes
        return array
      end

      def split type, pane
        if @type == NSPLIT
          @pane.height -= pane.height if type == HSPLIT
          @pane.width -= pane.width if type == VSPLIT
          @split1 = Split.new @pane
          @pane = nil
          @type = type
          @split2 = Split.new pane
        end
      end

      def delete pane
        if pane == @pane
          @pane = nil
        else
          if @split1.pane == pane
            @type = NSPLIT
            @pane = @split2.pane
            @pane.focused = true if @split1.pane
            @split1 = nil
            @split2 = nil
          elsif @split2.pane == pane
            @type = NSPLIT
            @pane = @split1.pane
            @pane.focused = true if @split2.pane
            @split1 = nil
            @split2 = nil
          end
        end
      end

    end
  end
end
