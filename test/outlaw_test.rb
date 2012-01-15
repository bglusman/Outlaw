require_relative 'test_helper'

module Outlaw
  describe LawDSL do
    it "returns a Rule which is called on code and returns true or false" do
      code = "@@"
      rule = LawDSL.parse(code)
      result1 = rule.call(<<CODE
class Whatever
  def badthing(here)
    @@here = here
  end
end
CODE
)

      result2 = rule.call(<<CODE
class Whatever
  def okaything(here)
    @here = here
  end
end
CODE
)

      result1.must_equal true
      result2.must_equal false
    end

    it "returns a block from build_block method" do
      block = LawDSL.build_block("@@")
      assert_kind_of Proc, block
    end
  end
end