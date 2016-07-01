module Rim
  class << self
    attr_accessor :io_thread
    attr_accessor :up
  end

  @up = false

  def self.init
    Core.init_core
    Rim.main_handler.call
  end
end
