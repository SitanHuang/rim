module Rim
  module Paint
    class Buffer
      def edit file, saved
        @file = file
        @file = File.absolute_path(file) if File.file?(@file)
        @saved = saved
        if File.file?(@file)
          content = File.read(@file)
          update_lines content
        end
      end
    end
  end
end
