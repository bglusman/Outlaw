require 'treetop'
require_relative 'outlaw_dsl'

parser = OutlawDSLParser.new

puts parser.parse("module :token end")
