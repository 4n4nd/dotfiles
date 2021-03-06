#!/usr/bin/env ruby

# make sure you have gem 'rubocop-git' in your Gemfile

require 'readline'

def input(prompt="", newline=false)
  prompt += "\n" if newline
  Readline.readline(prompt, true).squeeze(" ").strip
end

# http://stackoverflow.com/questions/3417896/how-do-i-prompt-the-user-from-within-a-commit-msg-hook#comment24746595_10015707
# reopen: Device not configured @ rb_io_reopen - /dev/tty (Errno::ENXIO) from .git/hooks/pre-commit-rubocop.rb:13:in ` '
begin
  STDIN.reopen('/dev/tty')
rescue Errno::ENXIO
  puts "\nUnable to reopen /dev/tty"
  exit 0
end
system("cd #{File.expand_path(__dir__+'/../../')} ; rubocop-git --cached")

exit 0 if $?.success?
exit 0 if input("Commit anyway? [y/N] ") == ?y
puts "\nConsider running \e[1mrubocop -a\e[22m on the offensive files"
exit 1
