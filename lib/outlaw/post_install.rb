module Outlaw
  class PostInstall
    def initialize(gem_installer)
      cmd = if system("which rvm > /dev/null")
        "rvm default do gem"
      elsif system("which rbenv > /dev/null")
        "rbenv exec gem"
      else
        "gem"
      end

      system(%Q{#{cmd} install pre-commit})
      system(%Q{pre-commit install})
      system(%Q{git config "pre-commit.checks" "white_space, pry, tabs, merge_conflict" })
    end
  end
end
