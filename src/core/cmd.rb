module Rim
  module Cmd
    COMMAND_HANDLERS = {}

    def self.call cmd, force, trailing
      handler = COMMAND_HANDLERS[cmd]
      raise RimError.new("Not a command - #{cmd}") if handler == nil
      handler.call force, trailing
    end
  end
end
