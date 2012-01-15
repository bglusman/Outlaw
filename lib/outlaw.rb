require 'ripper'
require_relative 'outlaw/law_dsl'
require_relative 'outlaw/enforcement'
require_relative 'outlaw/rule'
module Outlaw
  def self.outlaw(restriction, message)
    law = LawDSL.parse restriction
    Enforcement.add(law, message)
  end
  PARAM_TYPES = [:on_const, :on_ident, :on_ivar, :on_cvar]
  IGNORE_TYPES = [:on_sp, :on_nl, :on_op, :on_ignored_nl, :on_rparen, :on_lparen]

end