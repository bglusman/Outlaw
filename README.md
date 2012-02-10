#Outlaw

##Keep bad code out of your projects.  Your idea of bad code, no one elses.
##Because good documentation should be executable.

###NOTE: Outlaw can evaluate any version ruby code, *BUT* it runs on only 1.9 -- set your system ruby to 1.9 to use

### Part of MendicantUniversity.org S10 class, personal project.

The current version of outlaw takes a user provided configuration file
(currently named simply '.outlawed' in the project directory or user's home
directory) and parses a series of method calls to the outlaw method (defined
within the Outlaw module namespace, but module_eval'd so you don't need to
namespace the file).  You can also define constants in your .outlawed file as
collections of strings for use in your rules, but that will be addressed below.

Each call to the outlaw method consists of two string arguments, the first an
anti-pattern you wish to prohibit usage of in one or more projects, and the
second an explanation to be provided when the anti-pattern is detected.

### Syntax for rule creation:

Some examples are include in the .outlawed.example file for reference:

      outlaw "@@",                          "Class variables are evil"

      outlaw "protected",                   "use private or public, protected
                                            is silly in ruby"

      outlaw "eval",                        "never eval, rarely class_eval or
                                            instance_eval, but never eval"

      outlaw "module :token end",           "nest modules to avoid empty module
                                            declarations"

      outlaw "class :symbol < :core_class", "core classes implemented in c,
                                            can cause bad mojo"

      outlaw :trailing_whitespace


The first three examples are actual ruby keywords and features being outlawed
and may not require much explanation except to indicate that they are detected
via regular expression matches constructed from the strings, and attempt to use
word boundaries intelligently so that eval is detected but not module_eval.

The bottom two examples above use ruby symbols as standin variable or
parameter names for identifiers that are matched at runtime with local
variables, instance variables, class names and constants that may appear
within the ruby program being analyzed.  Here, :symbol can be any ruby symbol
if it appears only once, though if used multiple times it will only match the
the same identifier on subsequent usage.  :core_class as used above is a
special case where Outlaw has internally defined a constant called CORE_CLASS
as a collection of string objects each containing the name of one of ruby's
core classes.  You can define your own similar collections in the .outlawed
file (to be loaded from an external data file preferably, if more than a few
values) and then reference CONST_NAME as :const_name in your outlaw anti-
patterns as above.  Presently mutliple references to the same collection
are independent, but if there is interest special handling could be added to
also match specific instances of a collection much like the symbol handling.

The last one is a custom rule that calls a method defined on the Outlaw
module called 'trailing_whitespace' which returns a Rule object.  Any
such new methods may be defined in the .outlawed file (since it is
module_eval'd into the outlaw namespace) and then outawed the same way.


Outlaw currently ignores whitespace, parentheses and new lines, though I have
ideas to change this behavior dynamically in certain rules if desired.

Execute outlaw on your project from the root directory by simply entering
"outlaw" into your shell, or specify another directory to run
on with "outlaw /path/to/dir"

Before using outlaw in a project you should create a .outlawed file which
Outlaw will read rules from.

It comes with an example file (.outlawed.example) which is included in the
gem and will be loaded if no .outlawed file is found in current directory or
home directory, and will warn you to provide a real file (and provide
location of the sample file in your system from the gem installation).

###Planned features (unimplemented):
*Customize sensitivty , for instance whitespace is currently ignored, but
could enforce style conventions with some whitespace sensitive rules.
Also ignores parens, which might be required or prohibited in some
context.
*Specify AST-nodes of interest, and within them allow arbitrary amounts of
code with a :disjoint_code_seperator token.

This should allow, for instance, something like the following, which is not
currently possible to outlaw in a useful way:

    outlaw ":conditional_branch
        unless
        :disjoint_code_seperator
        else",
        "If you write unless else and think it makes sense then you are a
        cylon"

*Integrate Rails Best Practices gem, Reek gem, and perhaps others, so that individual issue
detections they provide can be added as rules in the outlawed file while
ignoring/not running other detection routines.

*Automate optional integration with rake task and/or githooks for
enforcement/notification of rules in a project.

*Specify classes of rules, such as log, warn and prevent for differing behavior regarding violations at runtime.
