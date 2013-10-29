require 'ripper'
require 'pry'
require_relative 'outlaw/law_parser'
require_relative 'outlaw/enforcement'
require_relative 'outlaw/rule'
require_relative 'outlaw/rule_methods'
require_relative 'outlaw/post_install'



module Outlaw
  extend self
  attr_accessor :ignore_types, :param_types

  def outlaw(pattern, message=nil)
    if pattern.kind_of?(String)
      rule = Rule.new(pattern, message)
      Outlaw::Enforcement.add(rule)
    else
      Outlaw::Enforcement.add(self.send(pattern))
    end
  end

  def enforce(dir=".")
    Outlaw::Enforcement.process_directory(dir)
  end

  def post_install(gem_installer)
    PostInstall.new(gem_installer)
  end

  #these come from ripper's Lexer
  self.param_types    = [:on_const, :on_ident, :on_ivar, :on_cvar]
  self.ignore_types   = [:on_sp, :on_nl, :on_ignored_nl, :on_rparen, :on_lparen]
  WHITESPACE          = [:on_sp, :on_nl, :on_ignored_nl]
  VERTICAL_WHITESPACE = [:on_nl, :on_ignored_nl]
  RULE_CASES          = [:whitespace_sensitive, :vertical_whitespace_sensitive]
  FUNCTION_CASES      = [:disjoint_code_seperator]
  SPECIAL_CASES       = RULE_CASES + FUNCTION_CASES

  CORE_CLASSES_FILE   = File.expand_path("../../data/core_classes.txt", __FILE__)
  CORE_CLASS          = File.readlines(CORE_CLASSES_FILE).map &:chomp
end
