module Rim

  class KeyChain
    attr_accessor :children
    attr_accessor :handler
    attr_accessor :key

    def initialize handler, key
      @handler = handler
      @key = key
      @children = []
    end

    # returns
    # 1- handler called, done
    # 2- child with key found, but no handler, wait for sub offsprings
    # 3- no child with key found
    def handle key, data, mode
      if @key == key
        if @handler
          @handler.call data, mode
          return 1
        else
          # no handler, go child
          mode.currentKeyChain = self
          return 2
        end
      else # if
        # check for children
        @children.each do |child|
          if child.key == key
            # let children decide
            return child.handle key, data, mode
          end
        end
        return 3
      end # else
    end

    def << handler
      @children << handler
    end
  end
end
