module Outlaw
  class Enforcement
    class << self
      attr_reader :rules
      def add(rule)
        @rules ||= []
        @rules << rule
      end

      def process_directory(path, output=:destructured)
        Dir.foreach(path) do |entry|
          next if entry == '.' or entry == '..'
          results = if File.directory?("#{path}/#{entry}")
                      process_directory("#{path}/#{entry}", output)
                    else
                      process_file("#{path}/#{entry}", output)
                    end
          puts results if output == :stdout
          results
        end
      end

      def process_file(file)
        handle(file).values
      end

      def handle(file)
        if file.match(/.rb$/)
          text = File.open(file) {|f| f.read}
          rules.reduce(error: false, output:"") do |rule, results|
            if rule.violation?(text)
              results[:output] += "Outlaw Violation in file:"   +
                                  "#{file}\nRestriction:\n"
                                  "#{rule.pattern}\n#{rule.message}\n\n"
              results[:error] = true unless rule.warning?
            end
            results
          end
        end
      end
    end
  end
end
