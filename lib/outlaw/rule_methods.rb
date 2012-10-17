module Outlaw
  def trailing_whitespace
    Rule.new("Trailing whitespace",
             "Trailing whitespace is ugly and can mess up version history") do |file|
             file.match(/ \n/)
           end
  end

  def touching_methods
    Rule.new("Touching methods",
             "Method definitions should have a blank line between end and next def") do |file|
            file.match(/\bend\b.*\n.*\bdef\b/)
          end
  end

end