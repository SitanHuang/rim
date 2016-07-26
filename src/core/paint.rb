# encoding: utf-8
require_relative 'theme.rb'
require_relative 'paint/pane'

module Rim
  module Paint
    def self.win_row; return STDIN.winsize[0]; end
    def self.win_col; return STDIN.winsize[1]; end

    class << self
      attr_accessor :theme
      attr_accessor :msg
      attr_accessor :old_col
      attr_accessor :old_row
    end
    @theme = {}
    @msg = nil

    @msgDurationStart = 0

    # init from Core#startup
    def self.init
      loadThemes
      refresh
      @old_col, @old_row = win_col, win_row
      onWindowResize
      # paint everything
      paint

    end

    def self.focusedPane
      panes.each_with_index do |pane, index|
        return index if pane.focused
      end
      nil
    end

    def self.onWindowResize
      rowChange = win_row - @old_row
      colChange = win_col - @old_col

      Rim.splitScreen.resize rowChange, colChange

      @old_col, @old_row = win_col, win_row
    end

    def self.refresh n = 0
      print "\n" * n if n > 0
      print T.clear
      print T.cursor(1, 1)
    end

    def self.paint
      Rim::Paint::refresh
      str = T.cursor(1,1)
      str << @theme[:ui][:root]
      panes.each do |pane|
        str << pane.draw
      end
      if @msg != nil and !@msg.empty?
        str << T.cursor(win_row, 1) << @msg
        if Time.now.to_i - @msgDurationStart >= 1
          hideMsg
        end
      end
      print str
    end

    def self.hideMsg
      @msg = ''
      @msgDurationStart = 0
      Rim.splitScreen.resize(win_row - Rim.splitScreen.endRow, 0)
    end

    def self.showMsg msg = ""
      hideMsg
      @msg = msg
      @msgDurationStart = Time.now.to_i
      Rim.splitScreen.resize(-1, 0)
    end

    def self.panes
      return Rim.splitScreen.toPanes if  Rim.splitScreen
      return []
    end

  end
end
