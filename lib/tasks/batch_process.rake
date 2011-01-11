#coding:utf-8
ENV['RAILS_ENV'] ||= "development"
#ENV['RAILS_ENV'] ||= "production"

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
        article.content=article.content.gsub(/http:\/\/i\d.quwan.cquom/, 'http://www.geilibuy.com')        
        article.content=article.content.gsub(/http:\/\/i\d.geilibuy.com/, 'http://www.geilibuy.com')        
        article.content=article.content.gsub("400-88-16016", '0579-85521605')        
        puts "ddddddddd"
        article.save
    end

end


desc "导入邮件,没有用,"
task :batch_import_email => :environment do
    require 'active_record'
    require 'activerecord-import'
    count=0
    count2=0
        r=[]
    #File.open("/home/mlzboy/my/b2c2/doc/allusernames.txt","r:UTF-8") do |file|
    File.open("/home/mlzboy/my/b2c2/doc/allusernames.txt","r") do |file|
        file.each_line do |line|
            count2+=1
            begin
                line=line.chomp.downcase.strip
                if line.size>0 and line.count("@")==1 and line.count("vancl")==0
                    #unless Subscription.exists?(:email=>email)
                        #Subscription.create(:email=>email)
                      r << Subscription.new(:email=>line)
                        count+=1
                        puts count
                    #end
                end
            rescue
                puts "==================="
                puts line
                puts count2
            end
            if r.size > 0 and r.size % 20000 == 0
                Subscription.import r
                r=[]
            end
        end
        if r.size!=0
            Subscription.import r
        end
    end
    puts "finished!"
end

desc "cron test"
task :cron_test do
    puts "dd"
end
