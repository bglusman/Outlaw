module Outlaw
  class Rule
    NoDetectionBlockProvided = Class.new(StandardError)
    def initialize(type=:ruby, scope=:file, &detection_block)
      raise NoDetectionBlockProvided unless detection_block
      @type, @scope, @detection_block = type, scope, detection_block
    end

    def call(code)
      @detection_block.call(code)
    end
  end
end