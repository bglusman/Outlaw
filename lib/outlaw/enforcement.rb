module Outlaw
  class Enforcement
    class << self
      attr_reader :rules
      def add(rule)
        @rules ||= []
        @rules << rule
      end

      def process_directory(path)
        Dir.foreach(path) do |entry|
          next if entry == '.' or entry == '..'
          if File.directory?("#{path}/#{entry}")
            process_directory("#{path}/#{entry}")
          else
            handle("#{path}/#{entry}")
          end
        end
      end

      def handle(file)
        if file.match(/.rb$/)
          text = File.open(file) {|f| f.read}
          rules.each do |rule|
            if rule.violation?(text)
              puts "Outlaw Violation in file: #{file}\nRestriction:"   +
                   "#{rule.restriction}\n\n#{rule.message}"
            end
          end
        end
      end
    end
  end
end
