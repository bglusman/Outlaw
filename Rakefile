#!/usr/bin/env rake

if Regexp.new('RUBYARCHDIR') === ARGV[0]
  require_relative "lib/outlaw/post_install"
  Outlaw::PostInstall.new(ARGV[0])
end

task :default => 'test'
task :test do
  sh "ruby test/outlaw_test.rb"
end
