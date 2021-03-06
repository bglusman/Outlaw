module Outlaw
  class Rule
    attr_reader :message, :pattern, :detection_block, :warning
    attr_accessor :modifications
    def initialize(pattern, message=nil, options={}, &detection_block)
      @pattern          = pattern
      @message          = message ? message : "Don't do this: #{pattern}"
      @warning          = options[:warning] || options[:info]
      @detection_block  = detection_block
    end

    def warning?
      warning
    end

    def violation?(code)
      @detection_block = LawParser.parse(pattern, self) if detection_block.nil?
      detect_violation(code)
    end

    private

    def detect_violation(code)
      defaults = apply_modifications
      result = detection_block.call(code)
      apply_modifications(defaults)
      result
    end

    def apply_modifications(restore=nil)
      return nil if modifications.nil? && restore.nil?
      default_ignores = Outlaw.ignore_types.clone
      default_params  = Outlaw.param_types.clone
      if modifications.include?(:whitespace_sensitive)
        WHITESPACE.each do |ws|
          Outlaw.ignore_types.delete(ws)
          Outlaw.param_types << ws
        end
      end
      if modifications.include?(:vertical_whitespace_sensitive)
        VERTICAL_WHITESPACE.each do |ws|
          Outlaw.ignore_types.delete(ws)
          Outlaw.param_types << ws
        end
      end
      Outlaw.ignore_types = restore.first if restore
      Outlaw.param_types  = restore.last  if restore
      [default_ignores, default_params]
    end

    public

    class << self
      def test(program, start_index, pattern)
        pattern_index = 0
        params = params_count_hash(pattern)
        start_index.upto(program.length) do |index|
          code = program[index]
          part = pattern[pattern_index]
          return false if code.nil?
          next if Outlaw.ignore_types.include?(token_type(code))
          return false unless match_token?(code, part, params[part])
          pattern_index +=1
          return true if pattern_index >= pattern.length
        end

        return false
        # got to end of program without completing pattern
      end

      private

      def match_token?(code, part, parameter)
        case part
        when Array
          match = true if part.include?(code)
        when Regexp
          match = true if code.match(part)
        when Symbol
          return false unless param_type_equal(token_type(code), part)
          #check count on first and count down subseq matches
          if parameter.first.nil? #history of parameter match if any
            parameter[0] = code
            parameter[1] -= 1     #first occurrence of parameter
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
        Outlaw.param_types.include? lex
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
