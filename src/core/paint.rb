# encoding: utf-8
require_relative 'theme.rb'
require_relative 'paint/pane'

module Rim
  module Paint
    def self.win_row; return STDIN.winsize[0]; end
    def self.win_col; return STDIN.winsize[1]; end

    class << self
      attr_accessor :theme
      attr_accessor :panes
      attr_accessor :old_col
      attr_accessor :old_row
    end
    @theme = {}
    @panes = []

    # init from Core#startup
    def self.init
      loadThemes
      refresh
      onWindowResize
      # paint everything
      paint
    end

    def self.focusedPane
      @panes.each_with_index do |pane, index|
        return index if pane.focused
      end
      nil
    end

    def self.onWindowResize
      # TODO

      @old_col, @old_row = win_col, win_row
    end

    def self.refresh n = 0
      print "\n" * n
      print T.clear
      print T.cursor(0, 0)
    end

    def self.paint
      Rim::Paint::refresh
      str = ''
      str << @theme[:ui][:root]
      @panes.each do |pane|
        str << pane.draw
      end
      print str
    end

  end
end
