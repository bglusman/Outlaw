module Outlaw
  def trailing_whitespace
    Rule.new("Trailing whitespace",
             "Trailing whitespace is ugly and can mess up version history") do |file|
             file.match(/ \n/)
           end
  end
end