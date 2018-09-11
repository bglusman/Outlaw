module Outlaw
  class Enforcement
    class << self
      def rules
        @rules ||= []
      end

      def add(rule)
        rules << rule
      end

      def process_directory(path)
        results = []
        Dir.foreach(path) do |entry|
          next if entry == '.' or entry == '..'
          f = File.join(path, entry)
          if File.directory?(f)
            results += process_directory(f)
          else
            results << handle(f)
          end
        end
        results.compact
      end

      def violation(file, rule)
        ["Outlaw Violation in file: #{file}",
         "Restriction:",
         rule.pattern,
         rule.message,
         nil
        ].join "\n"
      end

      def handle(file)
        return unless file.match(/.rb\z/)
        text = File.open(file) { |f| f.read }
        rules.map do |rule|
          violation(file, rule) if rule.violation?(text)
        end.compact
      end
    end
  end
end
