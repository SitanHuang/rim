require_relative 'io/keys'

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
      attr_accessor :currentKeyChain


      # name is string
      def initialize name
        @name = name
        @handlers = {}
        @currentKeyChain = nil
      end

      # type = symbol
      # handler = proc
      def register_handler type, handler
        @handlers[type] = handler
      end

      # for plugin injections
      def inject proc
        raise RimError, "#{@name}##{inject} not implemented!"
      end
    end
  end
end
