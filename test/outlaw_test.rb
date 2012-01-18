require_relative 'test_helper'

module Outlaw
  describe LawDSL do
    it "returns a Rule which is called on code and returns true or false" do
  end

  before do
        @okay_file = <<CODE
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

  end



    it "correctly builds rule for class var" do
      code1 = "@@"
      rule1 = LawDSL.parse(code1)

      class_var_file = <<CODE
  def badthing(here)
    @@here = here
  end
CODE

      class_result    = rule1.call(class_var_file)
      result1a        = rule1.call(@okay_file)
      class_result    .must_equal true
    end

    it "correctly builds rule for protected" do
      code2 = "protected"
      rule2 = LawDSL.parse(code2)

    protected_file = <<CODE
class Whatever
  protected
  def not_really
    :false
  end
end
CODE

      protected_result= rule2.call(protected_file)
      result2a = rule2.call(@okay_file)

      protected_result.must_equal true
      result2a        .must_equal false
    end


    it "correctly builds rule for eval" do
      code3 = "eval"
      rule3 = LawDSL.parse(code3)

    eval_file = <<CODE
  def not_really
    eval('1 + 1')
  end
CODE

      eval_result = rule3.call(eval_file)
      result3a    = rule3.call(@okay_file)

      eval_result.must_equal true
      result3a.must_equal false
    end


    it "correctly builds rule for module" do
      code4 = "module :name end"
      rule4 = LawDSL.parse(code4)

      module_file = <<CODE
module Thing
end
CODE

      module_result   = rule4.call(module_file)
      result4a        = rule4.call(@okay_file)

      module_result.must_equal true
      result4a.must_equal false
    end

    it "correctly builds rule for core" do
      code5 = "class :symbol < :core_class"
      rule5 = LawDSL.parse(code5)

core_file = <<CODE
class Whatever < String
  def badthing(here)
    @here = here
  end
end
CODE
      core_result     = rule5.call(core_file)
      result5a        = rule5.call(@okay_file)
      core_result     .must_equal true
      result5a.must_equal false
    end


#     it "correctly builds rule for unless else" do
#       code6 = "unless :symbols
#               :disjoint_code_seperator
#               else :more_symbols"
#       rule6 = LawDSL.parse(code6)

# core_file = <<CODE
# class Whatever < String
#   def badthing(here)
#     @here = here
#   end
# end
# CODE

    it "correctly builds rule for rescue nil" do
      code7 = "rescue nil"
      rule7 = LawDSL.parse(code7)

nil_file = <<CODE
begin
  "hi"
rescue nil
  "bye"
end
CODE
      nil_result     = rule7.call(nil_file)
      result7a       = rule7.call(@okay_file)
      nil_result     .must_equal true
      result7a.must_equal false
    end

    it "correctly builds rule for inherit struct.new" do
      code8 = "class :symbol < Struct.new"
      rule8 = LawDSL.parse(code8)

      struct_file = <<CODE
class MyClass < Struct.new("Customer", :name, :address)
CODE

      struct_result   = rule8.call(struct_file)
      result8a        = rule8.call(@okay_file)

      struct_result.must_equal true
      result8a.must_equal false
    end


#     end

    it "returns a hash with key counts and nil placeholders" do
      params = Rule.send(:params_count_hash, [/module/, :token1, :token2, :token1, /class/, :token3, /end/])
      params.keys.size.must_equal 3
      params[:token1].last.must_equal 2
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