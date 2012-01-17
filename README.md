#Outlaw

##Keep bad code out of your projects.  Your idea of bad code, no one elses.

### Part of MendicantUniversity.org S10 class, personal project.
From the included outlawed.rb example file for custom rule definition:

    module Outlaw
      outlaw "@@",                "Class variables are evil"
      outlaw "protected",         "use private or public, protected is silly in ruby"
      outlaw "module :token end", "nest modules to avoid empty module declarations"
      outlaw "eval",              "never eval, rarely class_eval or instance_eval, but never eval"
    end

### Proposed syntax for DSL:

  A defined collection exists for core classes, such that
    outlaw "class :symbol < :core_class",
                              "core classes implemented in c, can cause bad mojo"

  will outlaw subclassing from any core class


 Users can extend new defined collections and by creating new constants
defined as arrays of variable names to match in example code the same
way :core_class is used above

Disjoin code segments can be provided as a single example (assuming they
occur in the same file) by inserting a :disjoint_code_seperator token in
the outlawed sample definition.  I don't have a good use case for this
at present though, and since it will be difficult to handle disjoint
code across different files this may not be worthwhile...  but similar
special case symbol meanings may be useful, and suggestions or examples
are welcome. 
