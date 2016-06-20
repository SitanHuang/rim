#!/usr/bin/env ruby
# encoding: utf-8

require 'optparse'
require 'yaml'

options = {
  warn_op: 'stop',
  src: './src',
  prefix: '/usr/local',
  install: false
}

OptionParser.new do |opts|
  opts.banner = "The rim building program.\n" +
    "Usage: ./build.rb [options]"

  opts.separator ""
  opts.separator "Configuration:"

  opts.on '-w OP', '--warn OP ("ignore/stop")', ['ignore', 'stop'], "Operation when counter a warning." do |op|
    options[:warn_op] = op
  end

  opts.on '-s DIR', '--src DIR', "The source folder to build, default #{options[:src]}" do |dir|
    options[:src] = dir
  end

  opts.separator ""
  opts.separator "Installation:"

  opts.on '-p DIR', '--prefix DIR', "The installation folder prefix, default #{options[:prefix]},",
        "executable in /usr/local/bin/rim" do |dir|
    options[:prefix] = dir
  end

  opts.on '-I', '--install', "Start installation" do
    options[:install] = true
  end

  opts.separator ""
  opts.separator "Misc:"

  opts.on '-h', '--help', 'Prints this help' do
    puts opts
    exit
  end
end.parse!

puts "Configuration: \n#{YAML::dump options}"

def warn st
  if options[:warn_op] == 'ignore'
    puts "Warning: " + st
  elsif options[:warn_op] == 'stop'
    raise "Warning: " + st
    exit
  end
end

def error st
  puts "Error: " + st
  exit 1
end

puts ""

# ===== check version =====

if RUBY_VERSION.start_with? '2.0' or RUBY_VERSION.start_with? '2.1'
  warn "Ruby 2.[0,1].x might not be fully supported, use the lastest ruby instead :()"
elsif not RUBY_VERSION.start_with? '2.'
  error "Use the lastest ruby instead :()"
end

# ===== shell =====

warn 'Unknown shell compatibility, bash is recommended' if not ENV['SHELL'].end_with? '/bash'

# ===== source =====

if not File.exist? options[:src] + '/rim.rb'
  error "Source codes not found under directory #{options[:src]}"
end


# ===== check gems ===== (source first, requiring source codes)

puts "Checking gems"
require "#{options[:src]}/core/gems.rb"

# ===== check install =====

if not options[:install]
  puts "\nConfiguration completed. check -h for the next step :)\n"
  exit
end

# ===== installation =====

def cmd st
  puts st
  if not system(st)
    error "Failed!"
  end
end

cmd "mkdir #{options[:prefix]}/rim"

cmd "touch /usr/local/bin/rim"
cmd "chmod +x /usr/local/bin/rim"
cmd 'echo "#!/bin/env ruby" > /usr/local/bin/rim'
cmd "echo 'require \"#{options[:prefix]}/rim/rim.rb\"' >> /usr/local/bin/rim"

cmd "cp -r #{options[:src]}/* #{options[:prefix]}/rim"

puts\
"Installation complete.
Try use rim -v to see if that works. :)"
