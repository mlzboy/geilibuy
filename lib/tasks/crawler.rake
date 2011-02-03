#coding:utf-8
#require 'typhoeus'
require 'net/http'
require 'pp'
require 'nokogiri'  

ENV['RAILS_ENV'] ||= "production"

puts  Dir.pwd




namespace :xy1982 do
    desc "心叶列表页"
    task :list => :environment do
        puts "-----"

        urls=(1..183).map do |page|
            %Q{http://www.xy1982.com/category---page-#{page}.html}
        end
        
        # Generally, you should be running requests through hydra. Here is how that looks
        #hydra = Typhoeus::Hydra.new
        hydra = Typhoeus::Hydra.new(:max_concurrency => 5) # keep from killing some servers
        urls.each_with_index do |url,index|
          first_request = Typhoeus::Request.new(url)
          first_request.on_complete do |response|
            u=Url.find_by_myurl(url)
            u=Url.new unless u
            u.site="心叶"
            u.myurl=url
            u.success=true
            u.content=response.body
            u.kind="list"
            u.save
            
            #f=File.new(File.join("./crawler/xy/list","#{index+1}.html"), "w+")
            #begin
            #    #puts "ddddd"
            #    f.puts response.body
            #rescue
            #    puts "error"
            #    puts response.body.class
            #    f.puts response.body.to_utf8
            #ensure
            #    f.close
            #end
          end
          
          hydra.queue first_request
        end
        
        
        hydra.run # this is a blocking call that returns once all requests are complete
    end
    
    
    desc "抽取详细页链接集后"
    task :detail_link => :environment do
        Url.where(:kind=>"list").where(:site=>"心叶").where(:success=>true).all.each do |url|
            url.content.scan(/<a href="(pro-\d+\.html)"\s\S*?<img[\s\S]*?<\/a>/) do |name|
                puts name
                _url="http://www.xy1982.com/#{name[0]}"
                u=Url.find_by_myurl(_url)
                unless u
                    u=Url.new
                    u.myurl=_url
                    u.kind="detail"
                    u.site="心叶"
                    u.save
                end
            end
        end

    end
    
    desc "下载详细页链接"
    task :detail => :environment do
        while Url.where(:kind=>"detail").where(:site=>"心叶").where(:success=>false).count >0
            urls=Url.where(:kind=>"detail").where(:site=>"心叶").where(:success=>false).all.map{|url| url.url}
            #puts urls.size
            hydra = Typhoeus::Hydra.new(:max_concurrency => 1) # keep from killing some servers
            urls.each_with_index do |url,index|
              first_request = Typhoeus::Request.new(url)
              first_request.on_complete do |response|
                u=Url.find_by_url(url)
                #u=Url.new unless u
                #u.site="心叶"
                #u.myurl=url
                u.success=true
                u.content=response.body
                #u.kind="detail"
                u.save
              end
              hydra.queue first_request
            end
            
            
            hydra.run
        end
    end
    
    desc "下载详细页链接"
    task :detail2 => :environment do
        while Url.where(:kind=>"detail").where(:site=>"心叶").where(:success=>false).count >0
            urls=Url.where(:kind=>"detail").where(:site=>"心叶").where(:success=>false).all.map{|url| url.url}
            urls.each_with_index do |url,index|
                begin
                  url_str = URI.parse(url)
                  site = Net::HTTP.new(url_str.host, url_str.port)
                  site.open_timeout = 7
                  site.read_timeout = 7
                  path = url_str.query.blank? ? url_str.path : url_str.path+"?"+url_str.query
                  html=site.get2(path,{'accept'=>'text/html','user-agent'=>'Mozilla/5.0'})
                  puts html.body
                  puts html.class
                    u=Url.find_by_myurl(url)
                    puts "id============"
                    puts u.id
                    #u=Url.new unless u
                    #u.site="心叶"
                    #u.myurl=url
                    u.success=true
                    u.content=html.body
                    #u.kind="detail"
                    u.save
                rescue Exception => ex
                  p ex
                  puts url
                  puts "---"
                end
            end

        end
    end
    
    desc "上传图片"
    task :upload => :environment do
            #r=RestClient.post 'http://www.geilibuy.com/kindeditor/upload', :imgFile => File.new("/home/mlzboy/my/b2c2/public/themes/default/imgs/rm.png", 'rb')
            #pp r
        Image.where(:kind=>"image").where(:site=>"心叶").where(:success=>true).where(:big=>false).all.each do |image|
        
            #r=RestClient.post 'http://www.geilibuy.com/kindeditor/upload', :imgFile => File.new("/home/mlzboy/my/b2c2/public/themes/default/imgs/rm.png", 'rb')
            r=RestClient.post 'http://www.geilibuy.com/kindeditor/upload', :imgFile => File.new("./crawler/xy/images/#{image.new_img_url}", 'rb')
            pp r
            parsed_json = ActiveSupport::JSON.decode(r)
            url=parsed_json["url"]
            idx=url.rindex("?")
            if idx
                url=url[0...idx]
            end
            puts url
            image.real_img_url=url
            image.save
        end
    
    
#        require 'curb'
#        
#        fields_hash={
#            "id"=>"kindeditor",
#            "referMethod"=>"",
#            "imgBorder"=>"0",
#            "url"=>"http://",
#            "imgWidth"=>"",
#            "imgHeight"=>"",
#            "align"=>"",
#            "imgTitle"=>""
#            }
#        # prepare post data
#        post_data = fields_hash.map { |k, v| Curl::PostField.content(k, v.to_s) }
#        puts post_data
#        #post_data << 
#        
#
#        
#        
#        c = Curl::Easy.new("http://www.geilibuy.com/kindeditor/upload")
#c.multipart_form_post = true
#c.http_post(Curl::PostField.file('imgFile', '/home/mlzboy/my/b2c2/public/themes/default/imgs/rm.png'))
    end
    
    desc "替换图片链接"
    task :replace_img_url => :environment do
        #urls=[Url.where(:kind=>"detail").where(:site=>"心叶").where(:success=>true).first].each do |url|
        Url.where(:kind=>"detail").where(:site=>"心叶").where(:success=>true).all.each do |url|
            images=url.images
            if images.size > 0
                content=url.new_content1
                puts "========="
                puts content
                images.each do |image|
                #对于含中文的要记录没有编码的和编码后的两种效果到数据库中以便于在此处进行替换
                    if image.big==false and image.real_img_url.blank? ==false
                        puts "========="
                        content.gsub!(image.img_url,image.real_img_url)
                    end
                end
                if url.content!=content
                    url.new_content2=content
                    url.save
                    puts url.id
                end
            end
        end
    end
    desc "tojson"
    task :test_json => :environment do
        
    end
    desc "添加产品"
    task :batch_add_products => :environment do
        #[Url.where(:kind=>"detail").where(:site=>"心叶").where(:success=>true).first].each do |url|
        Url.where(:kind=>"detail").where(:site=>"心叶").where(:success=>true).all.each do |url|
            #r=RestClient.post 'http://www.geilibuy.com/admin/product/create', :imgFile => File.new("/home/mlzboy/my/b2c2/public/themes/default/imgs/rm.png", 'rb')
    
            server_url="http://www.geilibuy.com/admin/products"
            dict={}
            dict["utf8"]="✓"
            dict["authenticity_token"]="Vbvepv/f/AvGc7K2yvICaP2LrhKjrAId/BdSJEg12iI="
            dict["category_id"]=["1"]
            dict["brand_id"]=""

            dict["url_id"]=url.id.to_s
            product={}
            url.images.find_all{|elem| elem.big==true}.each_with_index do |image,index|
                idx=index+1
                if idx<5
                    product["i#{idx}"]=File.new("./crawler/xy/images/#{image.new_img_url}", 'rb')
                end
            end
            product["name"]=url.name
            product["sub_title"]=""
            product["p1"]=url.price*2.2
            product["p2"]=url.price*1.2
            product["p3"]=url.price
            product["p4"]="0.0"
            product["p5"]="0.0"
            product["view"]="0"
            product["sale"]="0"
            product["stock"]="1"
            product["on"]="1"
            product["promotion"]="0"
            product["new"]="0"
            product["score"]="0"
            product["s1"]="0"
            product["material"]=""
            product["weight"]=url.weight
            product["wrap"]=url.wrap
            product["size"]=url.size
            product["lucky"]="0"
            product["big"]="0"
            product["editor"]=""
            product["caution"]=""
            product["description"]=url.new_content2
            product["memo"]=""
            product["site"]=url.site
            product["myurl"]=url.myurl
            dict["product"]=product
            dict["commit"]="Create Product"
            RestClient.post(server_url,dict)
        end
    
    end
    
    desc "通过products表中name字段与urls表中name字段相关的行，有则将urls表中的myurl复制到products表中的myurl中，还有它的url_id值，目的是之前的batch_add_products操作有纰漏"
    task :update_products_info_from_urls => :environment do
        count=0
        Product.all.each do |product|
            u=Url.find_by_name(product.name)
            if u
                product.myurl=u.myurl
                product.url_id=u.id
                product.save false
                #puts product.myurl
                #puts product.url_id
                count+=1
                puts count
            end
        end
    end
    def price_truncate(price)
        if price.nil? or price.blank? or price == 0
            return price
        else
            a,b=price.to_s.split(".")
            if b.nil? ==false and b.size >1
                r=a+"."+b[0]
                return r.to_f
            else
                return price
            end
        end
    end
    desc "更新产品价格，使小数点后真实大于1的数只有一位如5.3而不是5.367或是5.360"
    task :update_price => :environment do
        Product.all.each do |product|
        #[Product.find(2048)].each do |product|
            puts product.p1
            puts product.p2
            puts product.p3
            puts product.p4
            puts product.p5
            product.p1=price_truncate(product.p1)
            product.p2=price_truncate(product.p2)
            product.p3=price_truncate(product.p3)
            product.p4=price_truncate(product.p4)
            product.p5=price_truncate(product.p5)
            product.save false
        end
    end
    
    desc "下架没有产品图片的产品"
    task :off_product_with_no_pic => :environment do
        count=0
        Product.all.each do |product|
        #[Product.find(1938)].each do |product|
            unless product.i1?
                puts product.id
                count+=1
                product.on=false
                product.save false
                puts count
            end
            #puts product.on

        end
    end
    
    desc "如果产品包含多个分类，且有初始“家居”这个分类，那么就将家居这个分类从categories_products表中移除，避免在产品详细页中都显示家居分类，因为默认是显示第一个分类"
    task :remove_default_category_for_product_has_many_categories => :environment do
        count=0
        c=Category.find_by_name("家居")#id=1

        Product.all.each do |product|
        #[Product.find(148)].each do |product|
            #puts product.categories.size
            categories=product.categories
            if categories.size > 1 and categories.include? c
                categories.delete c
                #puts categories.size
                count+=1
                puts count
            end
        end
    end
    
    desc "抽取图片及数据"
    task :product => :environment do
        #urls=[Url.where(:kind=>"detail").where(:site=>"心叶").where(:success=>true).first].each do |url|
        Url.where(:kind=>"detail").where(:site=>"心叶").where(:success=>true).all.each do |url|
            puts url.myurl
            html=url.content
            #doc = Nokogiri::HTML(html)
            
            # 获取页面上所有的链接
            #doc.xpath("//*[@id='pro_view_content']").each do |my|
            #  puts "#{my.html}"
            #end
            
            content=html.get_part(:s=>%Q{id="pro_view_content">},:e=>%Q{<div class="pro_links">}).strip()
            url.new_content1=content
            url.save
            images=content.scan(/<img[\s\S]*?src=("|')([^\1]*?)\1/)
            #[["\"", "images/upload/month_1101/201101150853162517.jpg"]]
            images.each do |elems|
                img_url=elems[1].strip
                
                image=Image.new
                image.url_id=url.id
                image.img_url=img_url
                image.site="心叶"
                image.kind="image"
                image.save
                
            end
            #sleep(1000)
        end
    end
    
    desc "抽取大图"
    task :big_img_extract => :environment do
        Url.where(:kind=>"detail").where(:site=>"心叶").where(:success=>true).all.each do |url|
        #[Url.where(:kind=>"detail").where(:site=>"心叶").where(:success=>true).first].each do |url|
            puts url.myurl
            html=url.content
            puts "==========================="
            content=html.get_part(:s=>%Q{<!--小图-->},:e=>%Q{</div>}).strip
            puts content

            images=content.scan(/<img[\s\S]*?src=("|')([^\1]*?)\1/)
            #[["\"", "images/upload/month_1101/201101150853162517.jpg"]]
            images.each do |elems|
                img_url=elems[1].strip
                
                image=Image.new
                image.url_id=url.id
                image.img_url=img_url
                image.site="心叶"
                image.kind="image"
                image.big=true
                image.save
                
            end

        end
    end

    desc "其它信息抽取"
    task :info_extract => :environment do
        Url.where(:kind=>"detail").where(:site=>"心叶").where(:success=>true).all.each do |url|
        #[Url.where(:kind=>"detail").where(:site=>"心叶").where(:success=>true).first].each do |url|
            puts url.myurl
            html=url.content
            puts "==========================="
            #name=html.get_part(:s=>%Q{商品名称},:e=>%Q{[}).filter_tags.filter_characters.strip
            #puts name
            #size=html.get_part(:s=>%Q{商品尺寸},:e=>%Q{[}).filter_tags.filter_characters.strip
            #puts size
            #weight=html.get_part(:s=>%Q{单个重量},:e=>%Q{[}).filter_tags.filter_characters.strip
            #puts weight
            #material=html.get_part(:s=>%Q{商品材质},:e=>%Q{[}).filter_tags.filter_characters.strip
            #puts material
            #wrap=html.get_part(:s=>%Q{商品包装},:e=>%Q{[}).filter_tags.filter_characters.strip
            #puts wrap
            price=html.get_part(:s=>%Q{商品价格},:e=>%Q{[}).filter_tags.filter_characters.strip.filter_price.strip
            puts price
            #url.name=name
            #url.size=size
            #url.weight=weight
            #url.material=material
            #url.wrap=wrap
            ##url.stock=true
            begin
                url.price=price.to_f
                url.save
            rescue
                puts price
                puts "error"
                url.myurl
            end
            puts url.id

        end
    end

    desc "检测图片是否真的下载完成了"
    task :image_down_success? => :environment do
        filename="201101150853162517.jpg"
        #puts File.exist?("./crawler/xy/images/#{filename}")
        #return nil
        puts "---"
        count=0
        Image.where(:kind=>"image").where(:site=>"心叶").where(:success=>true).all.each do |image|
            path="./crawler/xy/images/#{image.new_img_url}"
            unless File.exist?(path)
                puts path
                image.success=false
                image.save
                u=image.url
                u.success=false
                u.save
                puts image.img_url+"未成功"
            else
                count+=1
                puts "ok"
            end
        end
        puts count
    end

    desc "图片下载"
    task :image_down => :environment do
        while Image.where(:kind=>"image").where(:site=>"心叶").where(:success=>false).count >0
            Image.where(:kind=>"image").where(:site=>"心叶").where(:success=>false).all.each do |image|
            #Image.where(:id=>6122).all.each do |image|
                url=image.img_url
                unless url=~/^http:/
                    require 'uri'
                    url=URI.join("http://www.xy1982.com",URI.escape(image.img_url)).to_s
                else
                    url=URI.escape(image.img_url)
                end
                
                fullpath=""
                begin
                    filename=url.split("/").last
                    fullpath="./crawler/xy/images/#{filename}"
                    if File.exist?(fullpath)
                        #require 'uuid'
                        #filename=UUID.new.generate.to_s+"."+filename.split(".").last
                    else
                        url_str = URI.parse(url)
                        site = Net::HTTP.new(url_str.host, url_str.port)
                        site.open_timeout = 10
                        site.read_timeout = 10
                        path = url_str.query.blank? ? url_str.path : url_str.path+"?"+url_str.query
                        resp = site.get(path)
                        open(fullpath, "wb") { |file|
                          file.write(resp.body)
                         }
                        #html=site.get2(path,{'accept'=>'text/html','user-agent'=>'Mozilla/5.0'})

                    end
                    image.new_img_url=filename
                    image.success=true
                    image.save
                rescue Exception => ex
                  p ex
                  puts url
                  puts "---"
                  if File.exist?(fullpath)
                    File.delete(fullpath)
                  end
                end
            end
        end
    end



    
    
end