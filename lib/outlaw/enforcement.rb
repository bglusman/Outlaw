module Outlaw
  class Enforcement
    class << self
      attr_reader :laws
      def add(law)
        @laws ||= []
        @laws << law
      end

      def process_directory(path)
        Dir.foreach(path) do |entry|
          next if entry == '.' or entry == '..'
          if File.directory?(entry)
            # Dir.open(path + entry)
            process_directory("#{path}/#{entry}")
          else
            handle("#{path}/#{entry}")
          end
        end
      end

      def handle(file)
        if file.include?(".rb")
          text = File.open(file) {|f| f.read}
          laws.each do |law|
            if law.call(text)
              puts "Outlaw Violation in file: #{file}\nRestriction:"   +
                   "#{law.restriction}\n\n#{law.message}"
            end
          end
        end
      end
    end
  end
end