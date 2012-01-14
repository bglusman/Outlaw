module Outlaw
  class LawDSL
    def self.parse(restriction)
      tokens = restriction.split
      tokens.each_with_index do |token, i|
        tokens[i] = tokens[i][1..-1].to_sym if parameter?(token)
        tokens[i] = /#{tokens[i]}/ unless parameter?(token)
      end
      Rule.new build_block(tokens)
    end

    def self.parameter?(token)
      token[0].chr == ':'
    end

    def build_block(tokens)
      proc do |file|
        scanner = StringScanner.new(file)
      end
    end
  end
end