# rim, yet another vim-like editor

[![Join the chat at https://gitter.im/SitanHuang/rim](https://badges.gitter.im/SitanHuang/rim.svg)](https://gitter.im/SitanHuang/rim?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

## TODO
1. CommandMode(later CmdMode) initial - done
2. CmdMode exec & parse commands without autocomplete done
3. USBL release done
4. Autocomplete adapters for pane

### USBL release!!!!!!!
The current release code is called "USBL" which stands for USaBLe, this release
will be able to read/write and edit files with minimal normal, insert, and command mode.

### Usage
####Normal Mode

ESC = try to close the current pane

i = enter insert mode

: = enter command mode

####Command Mode

tabw/tw/tabwidth: change tab width

  1 argument: number, example: tw2

nu/number: set line numbers, add ! to disable

w: write file

  0..1 argument: file path

q: quit

  add ! to force quit

### We welcome everyone to chat in gitter or open issues for discussions!

**100% implemented in ruby**

![](https://raw.githubusercontent.com/SitanHuang/rim/master/src/screenshot.png)

## pros
1. easy customization
2. massive library collections with ruby gems
3. more supports of 256 colors
4. much more good default settings
5. makes development of an editor just a lot easier

## cons
1. not going to support mouse for a long period
  - but can easily do things you do with mouse with vim
2. BAD support for windows even you have ansicon
   installed within that little cmd.exe

## Installation
1. download everything into `folder`
2. `cd folder` or `cd folder/build`
3. `build/build.rb -h`
4. check the variables
5. execute without the install option
6. fix problems and do it with the install option


## Q & A
- **Q:**

  Do you uses curses or ncurses?

  **A:**

  No, everything involves with painting in a terminal is implemented by myself.

- **Q:**

  Why you create this thing?

  **A:**
  - It's fun to make an editor
  - To improve Vim's customizations
  - More convenient to work

# Status
5% done...

Surely you can contribute to it!

## Contribution
1. Open an issue states your intend
2. _we will talk about this later..._
