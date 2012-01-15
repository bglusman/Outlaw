module Outlaw
  module LawDSL
    class << self
      def parse(restriction)
        tokens = restriction.split
        tokens.each_with_index do |token, i|
          tokens[i] = tokens[i][1..-1].to_sym if parameter?(token)
          #tokens[i] = /#{tokens[i]}/ unless parameter?(token)
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
            return true if test_rule(program, index, pattern)
          end
          return false
        end
      end

      def test_rule(program, start_index, pattern)
        pattern_index = 0
        params = params_count_hash(pattern)
        start_index.upto(pattern.length) do |index|
          code = program[index]
          part = pattern[pattern_index]

          if code.match part
            pattern_index += 1
            next
          elsif part.respond_to?(:id2name) &&   #:on_kw, :on_const, :on_ident, :on_ivar, :on_cvar + others
            param_type_equal(Ripper.lex(code)[1], part)
            #check count on first and count down subseq matches
            if params[part].first.nil?
              params[part][0] = code
              params[part][1] -= 1
            else
              if params[part].first == code
                params[part][1] -= 1
                pattern_index += 1
                next
              else
                return false
              end
            end
          else
            return false
          end
        end   #we got to the end of pattern, so it was matched
        return true
      end

      def param_type_equal(lex, param)
        #for now just check if it's a variable type, not kw, ws or other token
        [:on_const, :on_ident, :on_ivar, :on_cvar].include? lex
      end

      def params_count_hash(pattern)
        params = Hash.new(0)
        pattern.each do |element|
          params[element] += 1 if parameter?(element)
        end
        output = {}                   #nil is placeholder for matched lex code
        params.keys.each {|key| output[key] = [nil, params[key]]}
        output
      end

    end
  end
end