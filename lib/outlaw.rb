require 'ripper'
require_relative 'outlaw/law_dsl'
require_relative 'outlaw/enforcement'
require_relative 'outlaw/rule'
module Outlaw
  def self.outlaw(restriction, message)
    law = LawDSL.parse(restriction, message)
    Enforcement.add(law)
  end

  def self.enforce(dir=".")
    Enforcement.process_directory(dir)
  end
  PARAM_TYPES         = [:on_const, :on_ident, :on_ivar, :on_cvar]
  IGNORE_TYPES        = [:on_sp, :on_nl, :on_ignored_nl, :on_rparen, :on_lparen]
  SPECIAL_CASES       = [:disjoint_code_seperator] #need to work on naming here
  CORE_CLASS          = []
  File.open('core_classes.txt') {|io| io.each_line {|line| CORE_CLASS << line.chomp}}
  #DEFINED_COLLECTIONS = [CORE_CLASS] # planned to use, but unneeded for now


end