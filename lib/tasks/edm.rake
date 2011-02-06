#coding:utf-8
namespace :edm do
    desc "发送每日团购邮件"
    task :everyday_tuan => :environment do
        t=Tuan.today
        Subscription.email_like("%qq.com%").subscribe_equals(true).sended_equals(false).limit(1).each do |sub|
                r=TuanMail.everyday(t,sub.email.chomp.strip)
                r.deliver
                sub.sended=true
                sub.save
        end
    end
end