#Outlaw

##Keep bad code out of your projects.  Your idea of bad code, no one elses.

###NOTE: Outlaw can evaluate any version ruby code, *BUT* it runs on only 1.9 -- set your system ruby to 1.9 to use

### Part of MendicantUniversity.org S10 class, personal project.
From the included .outlawed.example file for custom rule definition:

      outlaw "@@",                "Class variables are evil"
      outlaw "protected",         "use private or public, protected is silly in ruby"
      outlaw "module :token end", "nest modules to avoid empty module declarations"
      outlaw "eval",              "never eval, rarely class_eval or instance_eval, but never eval"

Execute outlaw on your project from the root directory by simply entering "outlaw", or specify another directory to run
on with "outlaw /path/to/dir"

Before using outlaw in a project you should create a .outlawed file which Outlaw will read laws from.
It comes with an example file (.outlawed.example) which is included in the gem and will be loaded if no .outlawed
file is found in current directory or home directory, and will warn you to provide a real file (and provide location
of the sample file in your system from the gem installation).

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
*Customize sensitivty , for instance whitespace is currently ignored, but
could enforce style conventions with some whitespace sensitive laws.
Also ignores parens, which might be required or prohibited in some
context.
*Specify AST-nodes of interest, and within them allow arbitrary amounts of code with
a :disjoint_code_seperator token.

This should allow, for instance, something like the following, which is not currently possible to outlaw in a useful way:

outlaw ":conditional_branch
        unless
        :disjoint_code_seperator
        else",
        "If you write unless else and think it makes sense then you are a cylon"

*Integrate Rails Best Practices gem, Reek gem, and perhaps others, so that individual issue
detections they provide can be added as laws in the outlawed file while
ignoring/not running other detection routines.

*Automate optional integration with rake task and/or githooks for
enforcement/notification of laws in a project.

*Specify classes of laws, such as log, warn and prevent for differing behavior regarding violations at runtime.
