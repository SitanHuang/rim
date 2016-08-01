require_relative '../panes/cmd_pane'
require_relative 'cursor'
require_relative 'normal'
require_relative 'insert'

normalMode = Rim::Core.modes[NormalMode.new.name]

class CmdMode < InsertMode
  include Rim, DefaultCursorHandlers

  def initialize
    super 'cmd'

    @currentKeyChain = nil
    @keyChain = KeyChain.new nil, nil

    register_handler(:exit, Proc.new do |mode, pane, force|
      @currentKeyChain = nil

      force = false if force == nil
      $cmd_mode_pane = nil

      Paint.showMsg "Command discarded"

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

      skey = key.gsub("\e", "^")
      T::DISPLAY_MAPPING.each do |k, v|
        skey = skey.gsub(k, v)
      end
      if status == 3 && (skey.length == 1 || key == "\t")
        pane.buffer.insert key
        status = 1
      end
      status
    end)

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
end

normalMode.inject(Proc.new do
  @keyChain << Rim::KeyChain.new(Proc.new { |data, mode|
    pane = data[:pane]
    $cmd_mode_pane = CmdModePane.new(
      row: Rim::Paint.win_row, col: 1,
      width: Rim::Paint.win_col,
      height: 1,
      mode: 'cmd'
    )
    pane.focused = true
  }, ":")
end)

Rim::Core.modes[NormalMode.new.name] = normalMode

mode = CmdMode.new

Rim::Core.register_mode mode
