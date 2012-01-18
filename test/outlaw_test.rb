require_relative 'test_helper'
require 'pry'

module Outlaw
  describe LawDSL do
    it "returns a Rule which is called on code and returns true or false" do
      code1 = "@@"
      rule1 = LawDSL.parse(code1)
      code2 = "protected"
      rule2 = LawDSL.parse(code2)
      code3 = "eval"
      rule3 = LawDSL.parse(code3)
      code4 = "module :name end"
      rule4 = LawDSL.parse(code4)
      code5 = "class :symbol < :core_class"
      rule5 = LawDSL.parse(code5)


class_var_file = <<CODE
  def badthing(here)
    @@here = here
  end
CODE

protected_file = <<CODE
class Whatever
  protected
  def not_really
    :false
  end
end
CODE

eval_file = <<CODE
  def not_really
    eval('1 + 1')
  end
CODE

module_file = <<CODE
module Thing
end
CODE

core_file = <<CODE
class Whatever < String
  def badthing(here)
    @here = here
  end
end
CODE

okay_file = <<CODE
class Whatever < Set
  def okaything(here)
    @here = here
  end
end

module WithContent
  def sumthin
    class_eval(1 + 1)
  end
end
CODE
      class_result    = rule1.call(class_var_file)
      protected_result= rule2.call(protected_file)
      eval_result     = rule3.call(eval_file)
      module_result   = rule4.call(module_file)
      core_result     = rule5.call(core_file)

      result1a = rule1.call(okay_file)
      result2a = rule2.call(okay_file)
      result3a = rule3.call(okay_file)
      result4a = rule4.call(okay_file)
      result5a = rule5.call(okay_file)


      result1a.must_equal false
      result2a.must_equal false
      result3a.must_equal false
      result4a.must_equal false
      result5a.must_equal false

      class_result    .must_equal true
      protected_result.must_equal true
      eval_result     .must_equal true
      module_result   .must_equal true
      core_result     .must_equal true
    end

    it "returns a hash with key counts and nil placeholders" do
      params = Rule.send(:params_count_hash, [/module/, :token1, :token2, :token1, /class/, :token3, /end/])
      params.keys.size.must_equal 3
      params[:token1].last.must_equal 2
    end

    it "returns a block from build_block method" do
      block = LawDSL.send(:build_block,"@@")
      assert_kind_of Proc, block
    end
  end
end