#!/usr/bin/env ruby
# encoding: utf-8

require_relative 'core/gems.rb'

# ===== env =====
$PWD = Dir.pwd
$HOME = ENV['HOME']
$SRC = File.dirname(__FILE__)
$EXEC = File.expand_path $0

def pwd
  $PWD
end

if __FILE__ == $0
  puts "Can you do that? no."
  exit 1
end

require_relative 'core/core.rb'

if $0.end_with? 'rim'
  Rim::Core.startup
end
# never reach here!
