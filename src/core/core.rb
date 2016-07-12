# encoding: utf-8
require_relative 'init/init'
require_relative 'init/main_handler'
require_relative 'init/io_handler'

require_relative 'io/files'

require_relative 'term/control'
require_relative 'RimError'
require_relative 'modes'
require_relative 'paint'

module Rim
  module Core
    class << self
      attr_reader :version
    end

    # all about versions stuff
    @version = {
      base: '0.0.04',
      suffix: 'preDEV',
      whole: '0.0.04-preDEV'
    }

    # the actual startup to the editor
    def self.startup
      Rim.init
    end

    # init core stuff
    def self.init_core
      Rim.io_thread = Thread.new(&Rim.io_handler)

      # load plugins, including core stuffs
      Dir["#{$SRC}/plugins/autoload/**/*.rb"].each do |file|
        require file
      end
    end
  end

end
