require 'ripper'
require_relative 'outlaw/law_dsl'
require_relative 'outlaw/enforcement'
require_relative 'outlaw/rule'



module Outlaw
  def self.outlaw(restriction, message)
    law = Outlaw::LawDSL.parse(restriction, message)
    Outlaw::Enforcement.add(law)
  end

  def self.enforce(dir=".")
    Outlaw::Enforcement.process_directory(dir)
  end
  PARAM_TYPES       = [:on_const, :on_ident, :on_ivar, :on_cvar]
  IGNORE_TYPES      = [:on_sp, :on_nl, :on_ignored_nl, :on_rparen, :on_lparen]
  #these come from ripper's Lexer
  CORE_CLASSES_FILE = File.expand_path("../../data/core_classes.txt", __FILE__)
  CORE_CLASS        = File.readlines(CORE_CLASSES_FILE).map &:chomp
end
