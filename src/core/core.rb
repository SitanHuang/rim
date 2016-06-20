# encoding: utf-8
require_relative 'term/control.rb'
require_relative 'paint.rb'

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

    # arguments parser
    def self.optParser
      return OptionParser.new do |parser|
        parser.banner = "rim #{@version[:whole]}"
        parser.separator "Usage: rim [options]"

        parser.on "-i", "--info", "Prints out enviromental infos" do
          puts\
"
Version: rim #{@version[:whole]}
Working directory: #{$PWD}
User home directory: #{$HOME}
Install directory: #{$SRC}
Executable file: #{$EXEC}
".strip

          exit
        end

        parser.on "-v", "--version", "Prints out the version(only)" do
          puts @version[:whole]
          exit
        end

        parser.on "-h", "--help", "Prints out this help" do
          puts parser
          exit
        end
      end
    end

    # the actual startup to the editor
    def self.startup
      Paint.init
      Paint.refresh
    end
  end

end
