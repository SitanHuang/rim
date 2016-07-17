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

    end)
    register_handler(:key, Proc.new do |mode, pane, key|
      status = -1
      if @currentKeyChain != nil
        status = @currentKeyChain.handle key, {pane: pane}, self
        @currentKeyChain = nil if status != 2
      else
        status = @keyChain.handle key, {pane: pane}, self
      end
      status
    end)

    inject_default_cursor_handlers
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
