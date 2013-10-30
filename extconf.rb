#!/usr/bin/env rake
if Regexp.new('RUBYARCHDIR') === ARGV[0]
  require_relative "lib/outlaw/post_install"
  Outlaw::PostInstall.new(ARGV[0])
end