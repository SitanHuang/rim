require_relative 'cursor'
require_relative 'normal'

normalMode = Rim::Core.modes[NormalMode.new.name]

class InsertMode < Rim::Core::Mode
  include Rim, DefaultCursorHandlers

  def initialize
    super 'insert'

    @currentKeyChain = nil
    @keyChain = KeyChain.new nil, nil

    register_handler(:exit, Proc.new do |mode, pane, force|
      @currentKeyChain = nil

      # TODO: force
      force = false if force == nil
      pane.mode = NormalMode.new.name

      pane.moveCol(-1).moveRow 0

    end)

    # returns
    # 1- handler called, done
    # 2- child with key found, but no handler, wait for sub offsprings
    # 3- no child with key found
    register_handler(:key, Proc.new do |mode, pane, key|
      status = -1
      if @currentKeyChain != nil
        status = @currentKeyChain.handle key, {pane: pane}, self
        @currentKeyChain = nil if status != 2
      else
        status = @keyChain.handle key, {pane: pane}, self
      end
#       '\u0041'..'\u005a'
#     |    '\u005f'
#     |    '\u0061'..'\u007a'
#     |    '\u00c0'..'\u00d6'
#     |    '\u00d8'..'\u00f6'
#     |    '\u00f8'..'\u00ff'
#     |    '\u0100'..'\u1fff'
#     |    '\u3040'..'\u318f'
#     |    '\u3300'..'\u337f'
#     |    '\u3400'..'\u3d2d'
#     |    '\u4e00'..'\u9fff'
# | '\uf900'..'\ufaff'
      skey = key.gsub("\e", "^").gsub("\t", "\\t")
      T::DISPLAY_MAPPING.each do |k, v|
        skey = skey.gsub(k, v)
      end
      if status == 3 && (skey.length == 1 || key.start_with?("\r"))
        pane.buffer.insert key
        status = 1
      end
      status
    end)

    inject_only_scroll
    inject_only_delete

    @keyChain << KeyChain.new(Proc.new { |data, mode|
      pane = data[:pane]
      moveRow(-1, pane)
    }, "\e[A")
    @keyChain << KeyChain.new(Proc.new { |data, mode|
      pane = data[:pane]
      moveRow(1, pane)
    }, "\e[B")
    @keyChain << KeyChain.new(Proc.new { |data, mode|
      pane = data[:pane]
      moveCol(-1, pane)
    }, "\e[D")
    @keyChain << KeyChain.new(Proc.new { |data, mode|
      pane = data[:pane]
      moveCol(1, pane)
    }, "\e[C")
  end

  def moveRow rowChange, pane
    buffer_size = pane.buffer.lines.size
    pane.buffer.row += rowChange
    pane.buffer.row = 1 if pane.buffer.row < 1
    pane.buffer.row = buffer_size if pane.buffer.row > buffer_size
    pane.buffer.col = pane.scroll_max_col
    if pane.buffer.col >= pane.buffer.lines[pane.buffer.row - 1].length
      pane.buffer.col = pane.buffer.lines[pane.buffer.row - 1].length
    end
    pane.buffer.col = 0 if pane.buffer.col < 0
    pane.calculateStartrow
    pane.calculateStartcol
  end

  def moveCol colChange, pane
    pane.buffer.col += colChange
    if pane.buffer.col > pane.buffer.lines[pane.buffer.row - 1].length
      if pane.buffer.lines[pane.buffer.row]
        pane.buffer.row += 1
        pane.buffer.col = 0
      else
        pane.buffer.col = pane.buffer.lines[pane.buffer.row - 1].length
      end
    elsif pane.buffer.col < 0
      if pane.buffer.row - 1 > 0
        pane.buffer.row -= 1
        pane.buffer.col = pane.buffer.lines[pane.buffer.row - 1].length
      else
        pane.buffer.col = 0
      end
    end
    pane.buffer.col = 0 if pane.buffer.col < 0
    pane.scroll_max_col = pane.buffer.col
    pane.calculateStartrow
    pane.calculateStartcol
    pane.calculateStartrow
    pane.calculateStartcol
  end

  def inject proc
    instance_eval(&proc)
  end
end

normalMode.inject(Proc.new do
  @keyChain << Rim::KeyChain.new(Proc.new { |data, mode|
    pane = data[:pane]
    pane.mode = 'insert'
  }, "i")
end)

Rim::Core.modes[NormalMode.new.name] = normalMode

mode = InsertMode.new

Rim::Core.register_mode mode
