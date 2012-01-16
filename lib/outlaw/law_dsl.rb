module Outlaw
  module LawDSL
    class << self
      def parse(restriction)
        tokens = restriction.split
        tokens.each_with_index do |token, i|
          tokens[i] = tokens[i][1..-1].to_sym if parameter?(token)
          tokens[i] = /#{tokens[i]}/ unless parameter?(token)
        end
        Rule.new(&build_block(tokens))
      end

      def parameter?(token)
        token[0].chr == ':'
      end

      def build_block(pattern)
        lambda do |file|
          program = Ripper.tokenize(file)
          program.each_with_index do |token, index|
            next unless token.match pattern.first
            return true if Rule.test(program, index, pattern)
          end
          return false
        end
      end
    end
  end
end