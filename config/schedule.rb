# Use this file to easily define all of your cron jobs.
#
# It's helpful, but not entirely necessary to understand cron before proceeding.
# http://en.wikipedia.org/wiki/Cron

# Example:
#
 #set :output, "/home/mlzboy/my/b2c2/log/cron_log.log"
 set :output, "/home/mlzboy/b2c2/current/log/cron_log.log"

 every 1.minute do
   #command "/usr/bin/some_great_command"
   #runner "MyModel.some_method"
   rake "cron_test"
 end
#
# every 4.days do
#   runner "AnotherModel.prune_old_records"
# end

# Learn more: http://github.com/javan/whenever
