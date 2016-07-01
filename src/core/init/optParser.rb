module Rim
  module Core
    # arguments parser
    def self.optParser
      return OptionParser.new do |parser|
        parser.banner = "rim #{@version[:whole]}"
        parser.separator "Usage: rim [options] [files]"

        parser.on "-i", "--info", "Prints out enviromental infos" do
          puts\
            "
            Version: rim #{@version[:whole]}
            Working directory: #{$PWD}
            User home directory: #{$HOME}
            Install directory: #{$SRC}
            Executable file: #{$EXEC}
            ".strip.gsub(/ {2}/, '')

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
  end
end
