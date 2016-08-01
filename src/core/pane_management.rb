require_relative 'paint/split.rb'

module Rim
  class << self
    attr_accessor :splitScreen
  end

  def self.edit filepath = ''
    filepath = '' if not filepath
    paneNum = Paint.focusedPane
    if not paneNum
      Rim.splitScreen = Paint::Split.new(Paint::Pane.new(
        row: 1, col: 1,
        width: Paint.win_col,
        height: Paint.win_row
      ))
      paneNum = Paint.focusedPane
    end
    pane = Paint.panes[paneNum]
    if filepath.empty?
      pane.buffer.edit(filepath, false)
    else
      # captures = filepath.match(/([^\/]+\/)*([^\/]+\/){0,1}([^\/]+)/).captures
      saved = File.exist? filepath
      raise RimError, "Cannot read FILE: #{filepath}" if saved and !File.file?(filepath)
      pane.buffer.edit(filepath, saved)
    end
  end

  def self.splitPane type, pane
    split = findFocusedSplit @splitScreen
    split.split type, pane
  end

  def self.findFocusedSplit split
    if split.type == Paint::Split::NSPLIT
      return split if split.pane.focused
      return nil
    else
      result = findFocusedSplit split.split1
      return result if result
      result = findFocusedSplit split.split2
      return result if result
    end
  end

  def self.delete_pane pane
    Rim.splitScreen.delete pane if Rim.splitScreen
  end
end
