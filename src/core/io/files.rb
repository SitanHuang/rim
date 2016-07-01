module Rim
  module IO
    class << self
      # extra files from command line
      attr_accessor :extra_args
      # file to edit from command line
      attr_accessor :file_arg
    end

    @extra_args = []
  end
end
