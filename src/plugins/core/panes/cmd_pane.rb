class CmdModePane < Rim::Paint::Pane
  def calculateStartcol
    max_line_length = 0
    max_line_length = @width - max_line_length + sep_width
    if @start_col + max_line_length - 2\
        < @buffer.col
      @start_col +=5
    elsif @start_col > @buffer.col
      @start_col = @buffer.col - (@width - @width / 4)
    end
    @start_col = 0 if @start_col < 0
    @buffer.col = 0 if @buffer.col < 0
    self
  end

  def initialize hash
    super hash
    @mode = 'cmd'
  end

  def calculateStartrow
    @start_row = 0
    @buffer.col = 0
    self
  end

  def draw
    calculateStartrow
    calculateStartcol

    str = ''

    row = @row
    # lines array index in buffer
    line = @start_row
    buffer_size = @buffer.lines.size
    until row > endRow do
      str << T.default
      # set the curser with the row
      str << T::cursor(row, @col)
      # fill gaps and reset for other
      # str << (@width < 5 ? '@' : ' ') * width
      str << ' ' * @width
      str << T::cursor(row, @col)
      # pane separator if
      # if more line in buffer
      if line < buffer_size
        # if line numbers enabled
        # == paint lines ==
        # calculate space left for content
        max_line_length = 0
        max_line_length = @width - max_line_length + sep_width

        buffer_line = @buffer.lines[line][@start_col..10**10]
        if buffer_line == nil
          buffer_line = ''
        end
        buffer_line = buffer_line
        buffer_line[0..max_line_length].chars.each_with_index do |char, col|
          # insert syntax attributes here for a todo
          str << char
        end
        str << ' ' * (max_line_length - buffer_line.length) if buffer_line.size < max_line_length
      end # line < buffer_size && row < endRow

      # next row
      row += 1
      line += 1
    end # until
    str << T.default
    if @focused && width >= 5
      # cursor row
      crow = @row + (@buffer.cursor_row - 1 - @start_row)
      ccol = @col - 1 + sep_width
      ccol += @buffer.col + 1 - @start_col
      str << T.cursor(crow, ccol)
    elsif @focused && width < 5
      str << T.cursor(@row, @col)
    end
    return str
  end
end

$cmd_mode_pane = nil

Rim::Paint::AFTER_PAINT_HANDLERS[:cmd_mode_pane] = lambda {
  $cmd_mode_pane.draw! if $cmd_mode_pane
}
