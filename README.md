#Outlaw

##Keep bad code out of your projects.  Your idea of bad code, no one elses.

### Part of MendicantUniversity.org S10 class, personal project.
From the included .outlawed.example file for custom rule definition:

    module Outlaw
      outlaw "@@",                "Class variables are evil"
      outlaw "protected",         "use private or public, protected is silly in ruby"
      outlaw "module :token end", "nest modules to avoid empty module declarations"
      outlaw "eval",              "never eval, rarely class_eval or instance_eval, but never eval"
    end

Before using outlaw in a project you must create (or copy the example) .outlawed file which Outlaw will read laws from.

### Syntax for DSL:

  A defined collection exists for core classes, such that

    outlaw "class :symbol < :core_class",
                              "core classes implemented in c, can cause bad mojo"

  will outlaw subclassing from any core class


Users can create defined collections like :core_class by creating new constants 
called, e.g. CORE_CLASS within the "module Outlaw" namespace which are
defined as arrays of string names to match in example code the same
way :core_class is used above.

###Planned features (unimplemented):
specify AST-nodes of interest, and within them allow arbitrary amounts of code with
a :disjoint_code_seperator token.

This should allow, for instance, something like the following, which is not currently possible to outlaw in a useful way:

outlaw ":conditional_branch
        unless
        :disjoint_code_seperator
        else",
        "If you write unless else and think it makes sense than you are a cylon"
