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
        status_line: lambda { |pane|
          return theme_default_status_line pane
        }
      }
    end

    def self.theme_default_status_line pane
      mode = Rim::Core.modes[pane.mode]
      replaceKey = lambda {
        |key|
        key = key.gsub("\e", "^").gsub("\n", "\\n").gsub("\r", "\\r").gsub("\t", "\\t")
        T::DISPLAY_MAPPING.each do |k, v|
          key = key.gsub(k, v)
        end
        key
      }

      rgb = RGB.new()
      reset = rgb.from_hex('#3F3F3F').ansi_bg + rgb.from_hex('#FFFFFF').ansi_fg

      if pane.width < 20
        return T.default + reset + ' ' * pane.width + T.default
      end

      str = T.default

      str << reset

      mode_str = ' ' + pane.mode + ' '
      display_name = ' ' + pane.buffer.display_name + ' '
      keyInfo = ""
      keyInfo = " Key not found (#{replaceKey.call Rim.last_key}) " if Rim.last_key_status == 3
      if mode.currentKeyChain != nil
        childrenInfo = ""
        mode.currentKeyChain.children.each do |child|
          childrenInfo += "#{replaceKey.call child.key}/"
        end
        childrenInfo.gsub!(/\/$/, '')
        keyInfo = " -- #{replaceKey.call mode.currentKeyChain.key} mode (#{childrenInfo}) -- "
      end

      str << rgb.from_hex('#db4437').ansi_bg << rgb.from_hex('#ffffff').ansi_fg << mode_str.upcase << reset
      str << display_name << keyInfo

      pos = " #{pane.buffer.row}:#{pane.buffer.col} "
      left = pane.width - mode_str.length - display_name.length - keyInfo.length - pos.length
      if left > 1
        str << rgb.from_hex('#db4437').ansi_fg << ' ' * left << pos << reset
      end
      str << T.default
      return str
    end
  end
end
