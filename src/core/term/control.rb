class RGB
  attr_accessor :r
  attr_accessor :g
  attr_accessor :b

  def initialize
    @r,@g,@b = 0,0,0
  end

  def from_hex hex
    array = hex.match(/#(..)(..)(..)/)
    @r = array[1].hex
    @g = array[2].hex
    @b = array[3].hex
    self
  end

  def ansi_bg
    "\e[48;2;#{r};#{g};#{b}m"
  end

  def ansi_fg
    "\e[38;2;#{r};#{g};#{b}m"
  end
end

module T
  # ===== text attributes =====
  def self.default; "\e[m"; end
  def self.bold; "\e[1m"; end
  def self.boldO; "\e[22m"; end
  def self.underline; "\e[4m"; end
  def self.underlineO; "\e[24m"; end
  def self.blink; "\e[5m"; end
  def self.blinkO; "\e[25m"; end
  def self.defFore; "\e[39m"; end
  def self.defBack; "\e[49m"; end
  def self.clear; "\e[2J"; end
  def self.cursor(row, col); "\e[#{row};#{col}H"; end

  DISPLAY_MAPPING = {
    "\x00" => '^@',  # Control space
    "\x01" => '^A',
    "\x02" => '^B',
    "\x03" => '^C',
    "\x04" => '^D',
    "\x05" => '^E',
    "\x06" => '^F',
    "\x07" => '^G',
    "\x08" => '^H',
    "\x09" => '^I',
    "\x0a" => '^J',
    "\x0b" => '^K',
    "\x0c" => '^L',
    "\x0d" => '^M',
    "\x0e" => '^N',
    "\x0f" => '^O',
    "\x10" => '^P',
    "\x11" => '^Q',
    "\x12" => '^R',
    "\x13" => '^S',
    "\x14" => '^T',
    "\x15" => '^U',
    "\x16" => '^V',
    "\x17" => '^W',
    "\x18" => '^X',
    "\x19" => '^Y',
    "\x1a" => '^Z',
    "\x1b" => '^[',  # Escape
    "\x1c" => '^\\',
    "\x1d" => '^]',
    "\x1f" => '^_',
    "\x7f" => '^?', # Backspace
  }
end

def read_char
  STDIN.echo = false
  STDIN.raw!

  input = STDIN.getc.chr
  if input == "\e" then
    input << STDIN.read_nonblock(3) rescue nil
    input << STDIN.read_nonblock(2) rescue nil
  end
ensure
  STDIN.echo = true
  STDIN.cooked!

  return input
end
