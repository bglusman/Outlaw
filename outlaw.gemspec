# -*- encoding: utf-8 -*-
lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "outlaw/version"

Gem::Specification.new do |s|
  s.name        = "outlaw"
  s.version     = Outlaw::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Brian Glusman"]
  s.email       = ["brian@neomindlabs.com"]
  s.homepage    = "https://github.com/bglusman/Outlaw"
  s.summary     = "Outlaw helps you enforce your opinions to keep bad code out your projects."
  s.extensions = ["Rakefile"]

  s.description = <<-DESC
      Keep bad code out of your projects. Your idea of bad code, no one elses.

      Outlaw defines an example based DSL for demonstrating anti-patterns and
      builds a rule for each anti-pattern that it alerts the user to violations
      when encountered in a project's codebase during scanning.

      Outlaw is a work in progress and contributions, suggestions and forks are welcome.
      Outlaw was a personal project for Mendicant University, Session 10 in Jan '12
  DESC

  s.files         = `git ls-files -z`.split("\0")
  s.test_files    = `git ls-files -z -- test/*`.split("\0")
  s.executables   = `git ls-files -z -- bin/*`.split("\0").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.post_install_message = <<POST_INSTALL

The law is on to you, better disappear into the wind.

POST_INSTALL

  s.add_runtime_dependency "pre-commit", "~> 0.10.0"
  s.add_runtime_dependency "pry"
  s.add_development_dependency "debt_ceiling", "~> 0.0.6"
  s.add_development_dependency "rake", "~> 0.9.0"
  s.add_development_dependency "minitest"
end
