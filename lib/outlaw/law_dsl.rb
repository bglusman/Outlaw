module Outlaw
  module LawDSL
    class << self
      def parse(restriction)
        tokens = restriction.split
        parsed_restriction = []
        tokens.each do |token|
          case
          when special_case?(token)
            next #TODO
          when defined_collection?(token)
            parsed_restriction << get_const(string_to_sym(token.upcase))
          when parameter?(token)
            parsed_restriction << string_to_sym(token)
          else
            parsed_restriction << /#{token}/
          end
        end
        Rule.new(&build_block(parsed_restriction))
      end

      private

      def parameter?(token)
        token[0].chr == ':'
      end

      def special_case?(token)
        SPECIAL_CASES.include? token
      end

      def defined_collection?(token)
        parameter?(token) && const_defined?(string_to_sym(token.upcase))
      end

      def string_to_sym(str)
        str[1..-1].to_sym
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