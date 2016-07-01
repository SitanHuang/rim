#!/usr/bin/env ruby
# encoding: utf-8

require_relative 'core/gems.rb'

# ===== env =====
$PWD = Dir.pwd
$HOME = ENV['HOME']
$SRC = File.dirname(__FILE__)
$EXEC = File.expand_path $0

if __FILE__ == $0
  puts "Can you do that? no."
  exit 1
end

require_relative 'core/core.rb'

Rim::Core.startup

# never reach here!
