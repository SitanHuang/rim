# encoding: utf-8
module Rim
  module Paint
    def self.theme_default
      rgb = RGB.new()
      Rim::Paint.theme = {
        ui: {
          root: T.default,
          pane: rgb.from_hex('#E0E0E0').ansi_bg +
                rgb.from_hex('#212121').ansi_fg,
          # panel separator
          pane_sep_char: ' ', # only 1 char!
          pane_sep: rgb.from_hex('#6E6E6E').ansi_bg,
          pane_numbers: rgb.from_hex('#FFFFFF').ansi_fg +
                        rgb.from_hex('#DB4437').ansi_bg
        },
        plain: {
          current_line: rgb.from_hex('#212121').ansi_bg +
                        rgb.from_hex('#FFFFFF').ansi_fg,
          line: T.default
        },
        status_line: Proc.new { |pane|
          theme_default_status_line pane
        }
      }
    end

    def self.theme_default_status_line pane
      rgb = RGB.new()
      reset = rgb.from_hex('#3F3F3F').ansi_bg + rgb.from_hex('#FFFFFF').ansi_fg

      if pane.width < 20
        return T.default + reset + ' ' * pane.width + T.default
      end

      str = T.default

      str << reset

      mode_str = ' ' + pane.mode + ' '
      display_name = ' ' + pane.buffer.display_name + ' '

      str << rgb.from_hex('#db4437').ansi_bg << rgb.from_hex('#ffffff').ansi_fg << mode_str << reset
      str << display_name

      pos = " #{pane.buffer.row}:#{pane.buffer.col} "
      left = pane.width - mode_str.length - display_name.length - pos.length
      if left > 1
        str << rgb.from_hex('#db4437').ansi_fg << ' ' * left << pos << reset
      end
      str << T.default
      return str
    end
  end
end
