#coding:utf-8
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