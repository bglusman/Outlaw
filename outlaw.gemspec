# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)
require "outlaw/version"

Gem::Specification.new do |s|
  s.name        = "outlaw"
  s.version     = Outlaw::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Brian Glusman"]
  s.email       = ["brian@neomindlabs.com"]
  s.homepage    = "https://github.com/bglusman/Outlaw"
  s.summary     = "Outlaw helps you enforce your opinions to keep bad code out your projects."
  s.rubyforge_project = "outlaw"

  s.description = <<-DESC
      Keep bad code out of your projects. Your idea of bad code, no one elses.

      Outlaw defines an example based DSL for demonstrating anti-patterns and
      builds a rule for each anti-pattern that it alerts the user to violations
      when encountered in a project's codebase during scanning.

      Outlaw is a work in progress and contributions, suggestions and forks are welcome.
      Outlaw was a personal project for Mendicant University, Session 10 in Jan '12
  DESC


  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "ripper-plus", "~> 1.3.0"

  s.add_development_dependency "rake", "~> 0.9.0"
  s.add_development_dependency "minitest"
end
