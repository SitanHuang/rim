# encoding: utf-8
module Rim
  module Paint
    def self.loadThemes
      Dir["#{$SRC}/themes/**/*.rb"].each do |file|
        require file
      end
      Rim::Paint.theme_default
    end
  end
end
