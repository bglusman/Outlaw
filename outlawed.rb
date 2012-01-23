
module Outlaw
	outlaw "@@",                "Class variables are evil"
	outlaw "protected",         "use private or public, protected is silly in ruby"
	outlaw "module :token end", "nest modules to avoid empty module declarations"
  outlaw "eval",              "never eval, rarely class_eval or instance_eval, but never eval"
  #ideas - http://rubyrogues.com/032-rr-ruby-antipatterns/
  outlaw "class :symbol < :core_class",
                              "core classes implemented in c, can cause bad mojo"

  # outlaw ":startline unless :tokens-not-end else",
  #                             "this just reads wrong"
  # outlaw "? true : false",    "unnecessary, just use the test itself"
  # outlaw "!!",                "bad style?"

end