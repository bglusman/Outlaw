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
