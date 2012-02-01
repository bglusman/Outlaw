require 'ripper'
require_relative 'outlaw/law_parser'
require_relative 'outlaw/enforcement'
require_relative 'outlaw/rule'



module Outlaw
  extend self
  attr_accessor :ignore_types

  def outlaw(pattern, message)
    rule = Rule.new(pattern, message)
    Outlaw::Enforcement.add(rule)
  end

  def enforce(dir=".")
    Outlaw::Enforcement.process_directory(dir)
  end
  PARAM_TYPES       = [:on_const, :on_ident, :on_ivar, :on_cvar]
  self.ignore_types = [:on_sp, :on_nl, :on_ignored_nl, :on_rparen, :on_lparen]
  WHITESPACE        = [:on_sp, :on_nl, :on_ignored_nl]
  SPECIAL_CASES     = [:whitespace_sensitive]
  #these come from ripper's Lexer
  CORE_CLASSES_FILE = File.expand_path("../../data/core_classes.txt", __FILE__)
  CORE_CLASS        = File.readlines(CORE_CLASSES_FILE).map &:chomp
end
