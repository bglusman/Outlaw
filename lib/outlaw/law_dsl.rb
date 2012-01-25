module Outlaw
  module LawDSL
    class << self
      def parse(restriction, message="")
        tokens = restriction.split
        parsed_restriction = []
        tokens.each do |token|
          case
          when special_case?(token)
            next #TODO - handle AST branches/disjoint code/meta-symbols to be defined
          when multipart?(token)  #this handles multi-token literals, Const.new etc
            parsed_restriction += Ripper.lex(token)
                                        .reduce([]){|array, tkn|
                                        array << token_type_regex(tkn) }
          when defined_collection?(token)
            parsed_restriction << Outlaw.const_get(string_to_sym(token.upcase))
          when parameter?(token)
            parsed_restriction << string_to_sym(token)
          else
            parsed_restriction += build_regex(token)
          end
        end
        Rule.new(message, restriction, &build_block(parsed_restriction))
      end

      private

      def token_type_regex(token)
        /#{token[2]}/
      end

      def parameter?(token)
        token[0].chr == ':'
      end

      def special_case?(token)
        SPECIAL_CASES.include? token
      end

      def defined_collection?(token)
        parameter?(token) && Outlaw.const_defined?(string_to_sym(token.upcase))
      end

      def string_to_sym(str)
        str[1..-1].to_sym
      end

      def build_regex(token)
        #fully expect this hack to come back & haunt me, but passes curr. examples
        [/\A#{token}/]
      end

      def multipart?(token)
        !parameter?(token) && Ripper.lex(token).count > 1
      end

      def build_block(pattern)
        lambda do |file|
          program = Ripper.tokenize(file)
          program.each_with_index do |token, index|
            next unless token.match(pattern.first)
            return true if Rule.test(program, index, pattern)
          end
          return false
        end
      end
    end
  end
end