# default cursor handlers

module DefaultCursorHandlers
  include Rim
  def inject_default_cursor_handlers
    inject(Proc.new {
      # in a context where self is a mode

      @keyChain << KeyChain.new(Proc.new { |data, mode|
        pane = data[:pane]
        pane.moveRow(-1)
      }, "\e[A")
      @keyChain << KeyChain.new(Proc.new { |data, mode|
        pane = data[:pane]
        pane.moveRow(1)
      }, "\e[B")
      @keyChain << KeyChain.new(Proc.new { |data, mode|
        pane = data[:pane]
        pane.moveCol(-1)
      }, "\e[D")
      @keyChain << KeyChain.new(Proc.new { |data, mode|
        pane = data[:pane]
        pane.moveCol(1)
      }, "\e[C")
      @keyChain << KeyChain.new(Proc.new { |data, mode|
        pane = data[:pane]
        pane.scroll(-$scrollRows).moveRow(-$scrollRows)
      }, "\e[5~")
      @keyChain << KeyChain.new(Proc.new { |data, mode|
        pane = data[:pane]
        pane.scroll($scrollRows).moveRow($scrollRows)
      }, "\e[6~")
    })
  end
end

$scrollRows = 3
