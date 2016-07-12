class NormalMode < Rim::Core::Mode
  def initialize
    super 'normal'
    register_handler(:exit, Proc.new do |pane, force|
      force = false if force == nil
      puts "\n" * 50
      puts Rim::Paint.panes
      Rim::Paint.panes.delete pane
      puts Rim::Paint.panes
      puts "\n" * 50
    end)
  end
end

mode = NormalMode.new

Rim::Core.register_mode mode
