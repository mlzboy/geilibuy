diff = Time.now.end_of_day() - Time.now

hours = diff.to_i / (60 * 60)
diff -= hours * (60 * 60)
minutes = diff.to_i / 60
diff -= minutes * 60
seconds = diff.to_i

puts "#{hours} hours, #{minutes} minutes, #{seconds} seconds"

