require 'ripper'
require_relative 'outlaw/law_dsl'
require_relative 'outlaw/enforcement'
require_relative 'outlaw/rule'

def outlaw(restriction, message)
  law = Outlaw::LawDSL.parse(restriction, message)
  Outlaw::Enforcement.add(law)
end

module Outlaw
  def self.enforce(dir=".")
    Outlaw::Enforcement.process_directory(dir)
  end
  PARAM_TYPES       = [:on_const, :on_ident, :on_ivar, :on_cvar]
  IGNORE_TYPES      = [:on_sp, :on_nl, :on_ignored_nl, :on_rparen, :on_lparen]
  SPECIAL_CASES     = [:disjoint_code_seperator] #need to work on naming here
  CORE_CLASSES_FILE = File.expand_path("../../data/core_classes.txt", __FILE__)
  CORE_CLASS        = File.readlines(CORE_CLASSES_FILE).map &:chomp
end
