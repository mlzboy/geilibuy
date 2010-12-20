#coding:utf-8
desc "任务1 -- 买菜"
task :purchaseVegetables do
puts "到沃尔玛去买菜。"
end

desc "任务2 -- 做饭"
task :cook => :environment do
puts "做一顿香喷喷的饭菜。"
puts User.all.count
end

desc "任务3 -- 洗衣服"
task :laundry do
puts "把所有衣服扔进洗衣机。"
end

