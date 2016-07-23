require_relative 'cursor'

class NormalMode < Rim::Core::Mode
  include Rim, DefaultCursorHandlers

  def initialize
    super 'normal'

    @currentKeyChain = nil
    @keyChain = KeyChain.new nil, nil

    register_handler(:exit, Proc.new do |mode, pane, force|
      @currentKeyChain = nil

      # TODO: force
      force = false if force == nil
      if !pane.buffer.saved and !force
        Paint.showMsg "Buffer not saved!"
      else
        Rim.delete_pane pane
      end

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

mode = NormalMode.new

Rim::Core.register_mode mode
