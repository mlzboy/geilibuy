#coding:utf-8
ENV['RAILS_ENV'] ||= "development"

desc "批量将趣玩网替换为给力百货网"
task :batch_article_content_replace => :environment do
    Article.all.each do |article|
        article.content=article.content.gsub("趣玩网","给力百货网")
        article.content=article.content.gsub("趣团","给力团")
        article.content=article.content.gsub("趣玩","给力百货")
        article.title=article.title.gsub("趣玩网","给力百货网")
        article.title=article.title.gsub("趣团","给力团")
        article.title=article.title.gsub("趣玩","给力百货")
        article.content=article.content.gsub("http://www.quwan.com","http://www.geilibuy.com")
        article.content=article.content.gsub("quwan.com","geilibuy.com")
        article.content=article.content.gsub("Quwan.com","GeiliBuy.com")
        article.content=article.content.gsub(/http:\/\/i\d.quwan.com/, 'http://www.geilibuy.com')        
        article.content=article.content.gsub(/http:\/\/i\d.geilibuy.com/, 'http://www.geilibuy.com')        
        puts "ddddddddd"
        article.save
    end

end


desc "导入邮件"
task :batch_import_email => :environment do
    count=0
    count2=0
    File.open("/home/mlzboy/my/b2c2/doc/allusernames.txt","r") do |file|
        file.each_line do |line|
            count2+=1
            begin
                if line.index("@") and line.index("vancl").nil?
                    email=line.chomp
                    unless Subscription.exists?(:email=>email)
                        Subscription.create(:email=>email)
                        count+=1
                        puts count
                    end
                end
            rescue
                puts "==================="
                puts line
                puts count2
            end
        end
    end
    put "finished!"
end

desc "cron test"
task :cron_test do
    puts "dd"
end
