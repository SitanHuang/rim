class NormalMode < Rim::Core::Mode
  def initialize
    super 'normal'
    register_handler(:exit, Proc.new do |pane|

    end)
  end
end

mode = NormalMode.new

Rim::Core.register_mode mode
