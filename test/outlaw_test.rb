require_relative 'test_helper'

module Outlaw
  describe LawDSL do
    it "returns a Rule which is called on code and returns true or false" do
      code1 = "@@"
      rule1 = LawDSL.parse(code1)
      code2 = "protected"
      rule2 = LawDSL.parse(code2)
      code3 = "eval"
      rule3 = LawDSL.parse(code3)
      code4 = "module :token end"
      rule4 = LawDSL.parse(code4)
bad_file = <<CODE
module Thing
end

class Whatever
  def badthing(here)
    @@here = here
  end
  protected
  def not_really
    eval('1 + 1')
  end
end
CODE

okay_file = <<CODE
class Whatever
  def okaything(here)
    @here = here
  end
end
CODE
      result1 = rule1.call(bad_file)
      result2 = rule2.call(bad_file)
      result3 = rule3.call(bad_file)
      result4 = rule4.call(bad_file)

      result1a = rule1.call(okay_file)
      result2a = rule2.call(okay_file)
      result3a = rule3.call(okay_file)
      result4a = rule4.call(okay_file)


      [result1a, result2a, result3a, result4a].each {|r| r.must_equal false }
      [result1, result2, result3, result4].each {|r| r.must_equal true }
    end

    it "returns a hash with key counts and nil placeholders" do
      params = Rule.send(:params_count_hash, [/module/, :token1, :token2, :token1, /class/, :token3, /end/])
      params.keys.size.must_equal 3
      params[:token1].last.must_equal 2
    end

    it "returns a block from build_block method" do
      block = LawDSL.build_block("@@")
      assert_kind_of Proc, block
    end
  end
end