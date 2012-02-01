require_relative 'test_helper'

module Outlaw
  describe LawParser do
    it "returns a Rule which is called on code and returns true or false" do
  end

  before do
        @okay_file = %{
          class Whatever < Set
            def okaything(here)
              @here = here
            end
          end

          module WithContent
            def sumthin
              class_eval('1 + 1')
            end

            def okishthing
            end
          end
        }
  end



    it "correctly builds rule for class var" do
      code1 = "@@"
      rule1 = Rule.new(code1)

      class_var_file = %{
        def badthing(here)
          @@here = here
        end
      }

      class_result    = rule1.violation?(class_var_file)
      result1a        = rule1.violation?(@okay_file)
      class_result    .must_equal true
    end

    it "correctly builds rule for protected" do
      code2 = "protected"
      rule2 = Rule.new(code2)

    protected_file = %{
      class Whatever
        protected
        def not_really
          :false
        end
      end
    }

      protected_result= rule2.violation?(protected_file)
      result2a = rule2.violation?(@okay_file)

      protected_result.must_equal true
      result2a        .must_equal false
    end


    it "correctly builds rule for eval" do
      code3 = "eval"
      rule3 = Rule.new(code3)

    eval_file = %{
      def not_really
        eval('1 + 1')
      end
    }

      eval_result = rule3.violation?(eval_file)
      result3a    = rule3.violation?(@okay_file)

      eval_result.must_equal true
      result3a.must_equal false
    end


    it "correctly builds rule for module" do
      code4 = "module :name end"
      rule4 = Rule.new(code4)

      module_file = %{
        module Thing
        end
      }

      module_result   = rule4.violation?(module_file)
      result4a        = rule4.violation?(@okay_file)

      module_result.must_equal true
      result4a.must_equal false
    end

    it "correctly builds rule for core" do
      code5 = "class :symbol < :core_class"
      rule5 = Rule.new(code5)

      core_file = %{
        class Whatever < String
          def badthing(here)
            @here = here
          end
        end
      }
      core_result     = rule5.violation?(core_file)
      result5a        = rule5.violation?(@okay_file)
      core_result     .must_equal true
      result5a.must_equal false
    end

    it "correctly builds rule for rescue nil" do
      code7 = "rescue nil"
      rule7 = Rule.new(code7)

      nil_file = %{
        begin
          "hi"
        rescue nil
          "bye"
        end
      }
      nil_result     = rule7.violation?(nil_file)
      result7a       = rule7.violation?(@okay_file)
      nil_result     .must_equal true
      result7a.must_equal false
    end

    it "correctly builds rule for inherit struct.new" do
      code8 = "class :symbol < Struct.new"
      rule8 = Rule.new(code8)

      struct_file = %{
        class MyClass < Struct.new("Customer", :name, :address)
      }

      struct_result   = rule8.violation?(struct_file)
      result8a        = rule8.violation?(@okay_file)

      struct_result.must_equal true
      result8a.must_equal false
    end

    it "correctly builds whitespace sensitive rule" do
      code9 = ":vertical_whitespace_sensitive end\ndef"
      rule9 = Rule.new(code9)

      def_file = %{
      class Mine
        def method
          true
        end
        def method2
          false
        end
      end
      }

      def_result    = rule9.violation?(def_file)
      result9a      = rule9.violation?(@okay_file)

      def_result.must_equal true
      result9a.must_equal false
    end

    it "returns a hash with key counts and nil placeholders" do
      params = Rule.send(:params_count_hash, [/module/, :token1, :token2, :token1, /class/, :token3, /end/])
      params.keys.size.must_equal 3
      params[:token1].last.must_equal 2
    end

    it "returns a block from build_block method" do
      block = LawParser.send(:build_block,"@@")
      assert_kind_of Proc, block
    end
  end
end