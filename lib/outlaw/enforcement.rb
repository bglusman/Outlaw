module Outlaw
  class Enforcement
    class << self
      attr_reader :rules
      def add(rule)
        @rules ||= []
        @rules << rule
      end

      def process_directory(path, output=:destructured)
        results = {error: nil, output:""}
        Dir.foreach(path) do |entry|
          next if entry == '.' or entry == '..'
          result = if File.directory?("#{path}/#{entry}")
                      process_directory("#{path}/#{entry}", output)
                    else
                      handle("#{path}/#{entry}")
                    end
          results[:error] ||= result[:error]
          results[:output] += result[:output] if result[:output]
        end
        puts results[:output] if (output == :stdout && results[:output].length > 0)
        results
      end

      def process_file(file)
        handle(file).values
      end

      def handle(file)
        if file.match(/.rb$/)
          text = File.open(file) {|f| f.read}
          rules.reduce(error: false, output:"") do |results, rule|
            if rule.violation?(text)
              results[:output] += ("Outlaw Violation in file:"   +
                                  "#{file}\nRestriction:\n"
                                  "#{rule.pattern}\n#{rule.message}\n\n")
              results[:error] = true unless rule.warning?
            end
            results
          end
        else
          {}
        end
      end
    end
  end
end
