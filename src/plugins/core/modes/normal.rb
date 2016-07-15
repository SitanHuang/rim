class NormalMode < Rim::Core::Mode
  include Rim

  def initialize
    super 'normal'

    @currentKeyChain = nil
    @keyChain = KeyChain.new nil, nil

    register_handler(:exit, Proc.new do |mode, pane, force|
      @currentKeyChain = nil

      # TODO: force
      force = false if force == nil
      Rim::Paint.panes.delete pane

    end)
    register_handler(:key, Proc.new do |mode, pane, key|
      status = -1
      if @currentKeyChain != nil
        status = @currentKeyChain.handle key
        @currentKeyChain = nil if status != 2
      else
        status = @keyChain.handle key
      end
      status
    end)
  end
end

mode = NormalMode.new

Rim::Core.register_mode mode
