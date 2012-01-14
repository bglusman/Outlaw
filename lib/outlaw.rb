require 'strscan'
require_relative 'outlaw/law_dsl'
require_relative 'outlaw/enforcement'
module Outlaw
  def self.outlaw(restriction, message)
    law = LawDSL.parse restriction
    Enforcement.add(law, message)
  end
end