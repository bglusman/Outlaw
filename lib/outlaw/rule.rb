module Outlaw
  class Rule
    def initialize(type=:ruby, scope=:file, &detection_block)
      @type, @scope, @detection_block = type, scope, detection_block
    end
  end
end