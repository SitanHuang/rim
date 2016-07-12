class NormalMode < Rim::Core::Mode
  def initialize
    super 'normal'
  end
end

mode = NormalMode.new

Rim::Core.register_mode mode
