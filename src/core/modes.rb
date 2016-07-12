module Rim
  module Core
    class << self
      attr_accessor :modes
    end
    @modes = {}

    def self.register_mode mode
      @modes[mode.name] = mode
    end

    class Mode
      attr_accessor :name
      attr_accessor :handlers

      # name is string
      def initialize name
        @name = name
        @handlers = {}
      end

      # type = symbol
      # handler = proc
      def register_handler type, handler
        @handlers[type] = handler
      end
    end
  end
end
