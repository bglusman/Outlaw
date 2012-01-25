module Outlaw
  class Rule
    NoDetectionBlockProvided = Class.new(StandardError)
    attr_reader :message, :restriction
    def initialize(message, restriction, &detection_block)
      raise NoDetectionBlockProvided unless detection_block
      @message          = message
      @restriction      = restriction
      @detection_block  = detection_block
    end

    def call(code)
      @detection_block.call(code)
    end

    class << self
      def test(program, start_index, pattern)
        pattern_index = 0
        params = params_count_hash(pattern)
        start_index.upto(program.length) do |index|
          code = program[index]
          part = pattern[pattern_index]

          next if IGNORE_TYPES.include? token_type(code)
          return false unless match_token?(code, part, params[part])
          pattern_index +=1
          return true if pattern_index >= pattern.length
        end

        return false
        # got to end of program without completing pattern
      end

      private

      def match_token?(code, part, parameter)
        #RegEx responds to .source but not .to_sym, symbols vice versa.
        #Is this really better than checking is_type_of? Smells since not using methods
        if (part.respond_to?(:to_a)   && part.include?(code))
          match = true
        elsif (part.respond_to?(:source) && code.match(part))
          match = true
        elsif (part.respond_to?(:to_sym) && param_type_equal(token_type(code), part))
          #check count on first and count down subseq matches
          if parameter.first.nil? #history of parameter match if any
            parameter[0] = code
            parameter[1] -= 1  #first occurrence of parameter
            match = true
          else
            if parameter.first == code
              parameter[1] -= 1
              match = true
            else
              match = false
            end
          end
        else
          match = false
        end

        match
      end


      def param_type_equal(lex, param)
        #for now just check if it's a variable type, not kw, ws or other token
        PARAM_TYPES.include? lex
      end

      def token_type(code)
        Ripper.lex(code).flatten(1)[1] #Ripper's name for token type is returned in array
      end

      def params_count_hash(pattern)
        params = Hash.new(0)
        pattern.each do |element|
          params[element] += 1 if element.respond_to?(:to_sym)
        end
        output = {}                   #nil is placeholder for matched lex code
        params.keys.each {|key| output[key] = [nil, params[key]]}
        output
      end
    end
  end
end
