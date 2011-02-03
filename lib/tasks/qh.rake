#coding:utf-8
require 'net/http'
require 'pp'
require 'nokogiri'  
require 'uri'
require 'set'
require 'mini_magick'
require 'digest/md5'

ENV['RAILS_ENV'] ||= "production"
namespace :qh do
    desc "获取俏货全部商品页面中的各分类链接及其名称"
    task :get_category_links_index_page => :environment do
        url="http://www.92pifa.com/"
        begin
          url_str = URI.parse(url)
          site = Net::HTTP.new(url_str.host, url_str.port)
          site.open_timeout = 7
          site.read_timeout = 7
          path = url_str.query.blank? ? url_str.path : url_str.path+"?"+url_str.query
          html=site.get2(path,{'accept'=>'text/html','user-agent'=>'Mozilla/5.0'})
          puts html.body.to_gbk
          puts html.class
            u=Url.find_by_myurl(url)
            puts "id============"
            #puts u.id
            u=Url.new unless u
            u.site="俏货"
            u.myurl=url
            u.success=true
            u.content=html.body.to_gbk
            u.kind="index"
            u.save
        rescue Exception => ex
          p ex
          puts url
          puts "---"
        end
    end
    
    
    desc "从get_category_links的页面中抽取各个专题页的首页的链接"
    task :extract_topic_first_page_link => :environment do
        u=Url.where(:site=>"俏货").where(:kind=>"index").first
        html=u.content
        tags=["ul","em","dd","input","h1","h2","h3","br","b","span","strong","p","hr","strong","p","hr","font","div","td","tr","img","form","table"]
        #过滤掉除了<a href="/prolist-b-30-0----/" class="progo">节日专区</a>形式之外的所有内容，只留链接
        content=html.get_part(:s=>%Q{<td height="36" background="/img_YWshop/Y1/cpfl2.png" style="padding-top:6px;">},:e=>%Q{</table></td>}).filter_tags(tags).strip()
        #提取链接地址和名称        
        arrs=content.scan(/<a[\s\S]*?href=("|')([\s\S]*?)\1[\s\S]*?>([\s\S]*?)<[\s\S]*?a[\s\S]*?>/)
        arrs.each do |r| 
            url=r[1]
            name=r[2]
            unless url=~/^http:/
                url=URI.join("http://www.92pifa.com",URI.escape(url)).to_s
            else
                url=URI.escape(url)
            end
            puts url
            puts name

            u=Url.find_by_myurl(url)
            u=Url.new unless u
            u.site="俏货"
            u.myurl=url
            #u.success=true
            u.kind="first"#第一页
            #u.parent_ids=u.id.to_s
            u.href_name=name.strip
            u.save

        end
    end
    desc "download all first kind page"
    task :down_all_first_pages => :environment do
        firsts=Url.where(:site=>"俏货").where(:kind=>"first").where(:success=>false).all
        error=0
        success=0
        firsts.each do |first|
            begin
              url_str = URI.parse(first.myurl)
              site = Net::HTTP.new(url_str.host, url_str.port)
              site.open_timeout = 7
              site.read_timeout = 7
              path = url_str.query.blank? ? url_str.path : url_str.path+"?"+url_str.query
              html=site.get2(path,{'accept'=>'text/html','user-agent'=>'Mozilla/5.0'})
              puts html.body.to_gbk
              puts html.class
                first.content=html.body.to_gbk
                first.success=true
                first.save
                success+=1
            rescue Exception => ex
                error+=1
              p ex
              puts first.myurl
              puts "---"
            end
        end
        puts "success",success
        puts "error",error
    end
    
    desc "从extract_topic_first_page_link的页面中抽取各该专题剩余的链接"
    task :extract_topic_left_page_links => :environment do
        firsts=Url.where(:site=>"俏货").where(:kind=>"first").where(:success=>true).all
        #firsts=[firsts.first]
        firsts.each do |first|
            html=first.content#专题第一页的内容
            #找出这个专题所有的列表页面链接
            #html=%q{<td height="24" align="center">共<font color="#FF0000">2</font>页 这是第<font color="#FF0000">[1]}
            pages=html.get_part(:s=>%q{共},:e=>%q{页 这是第},:left=>false).filter_tags.strip.to_i
            
            puts pages
            if pages>1
                (2..pages).each do |page|
                    url=first.myurl[0..-7]+page.to_s+".html"
                    puts url
                    u=Url.find_by_myurl(url)
                    u=Url.new unless u
                    u.site="俏货"
                    u.myurl=url
                    #u.success=true
                    u.kind="next"#第一页
                    u.href_name=first.href_name
                    u.save
                end
            end
            
        end
    end    
    
    desc "download all next kind page"
    task :down_all_next_pages => :environment do
        firsts=Url.where(:site=>"俏货").where(:kind=>"next").where(:success=>false).all
        error=0
        success=0
        firsts.each do |first|
            begin
              url_str = URI.parse(first.myurl)
              site = Net::HTTP.new(url_str.host, url_str.port)
              site.open_timeout = 7
              site.read_timeout = 7
              path = url_str.query.blank? ? url_str.path : url_str.path+"?"+url_str.query
              html=site.get2(path,{'accept'=>'text/html','user-agent'=>'Mozilla/5.0'})
              puts html.body.to_gbk
              puts html.class
                first.content=html.body.to_gbk
                first.success=true
                first.save
                success+=1
            rescue Exception => ex
                error+=1
              p ex
              puts first.myurl
              puts "---"
            end
        end
        puts "success",success
        puts "error",error
    end
    
    desc "extract product detail page links"
    task :extract_product_detail_page_links => :environment do
        #从各个列表页抽取详细页面的链接
        #lists=Url.find_by_sql("select * from urls where success=1 and (kind='first' or kind='next') and site='俏货' limit 0,1")
        lists=Url.find_by_sql("select * from urls where success=1 and (kind='first' or kind='next') and site='俏货'")
        lists.each do |list|
            puts list.myurl
            #<a class="protitle" target="_blank" title="B847特价饰品八角手镯/手环 颜色随机" href="/Product/?Show_4253.html">B847特价饰品八角手镯/手环 颜色随机</a>
            list.content.scan(/<a href=("|')(\/Product\/\?Show_\d*\.html)\1[\s\S]*?<img[\s\S]*?<\/a>/) do |r|
                puts r[1]
                _url=URI.join("http://www.92pifa.com",r[1]).to_s
                puts _url
                u=Url.find_by_myurl(_url)
                if u
                    puts "already exists"
                    unless list.href_name.blank?
                        if u.href_name.blank?
                            u.href_name=list.href_name
                        else
                            a=u.href_name.split(",") << list.href_name
                            u.href_name=a.uniq.join(",")
                        end
                    end
                else
                    u=Url.new
                    u.href_name=list.href_name unless list.href_name.blank?
                    u.myurl=_url
                    u.kind="detail"
                    u.site="俏货"
                end
                u.save
            end
        end
    end
    desc "download all product detail pages"
    task :down_all_product_detail_pages => :environment do
        while Url.where(:site=>"俏货").where(:kind=>"detail").where(:success=>false).count >0
            puts "新一轮"
            firsts=Url.where(:site=>"俏货").where(:kind=>"detail").where(:success=>false).all
            error=0
            success=0
            firsts.each do |first|
                begin
                  url_str = URI.parse(first.myurl)
                  site = Net::HTTP.new(url_str.host, url_str.port)
                  site.open_timeout = 7
                  site.read_timeout = 7
                  path = url_str.query.blank? ? url_str.path : url_str.path+"?"+url_str.query
                  html=site.get2(path,{'accept'=>'text/html','user-agent'=>'Mozilla/5.0'})
                  puts html.body.to_gbk
                  puts html.class
                    first.content=html.body.to_gbk
                    first.success=true
                    first.save
                    success+=1
                rescue Exception => ex
                    error+=1
                  p ex
                  puts first.myurl
                  puts "---"
                end
            end
            puts "success",success
            puts "error",error
            sleep(60)
        end
    end
    

    

    
    desc "抽取产品详细页中的主体部分的内容到urls#new_content1中,并将内容中的image放到images表中"
    task :extract_content => :environment do
        #urls=[Url.where(:kind=>"detail").where(:site=>"俏货").where(:success=>true).first].each do |url|
        Url.find_each(:conditions=>"kind='detail' and site='俏货' and success=1") do |url|
        #Url.where(:kind=>"detail").where(:site=>"俏货").where(:success=>true).all.each do |url|
            puts url.myurl
            html=url.content
            content=html.get_part(:s=>%q{<td height="37" style="font-size:14px; line-height:170%;" class="12lan">},:e=>/<\/td>[\s\S]*?<\/tr>[\s\S]*?<\/table>[\s\S]*?<hr width="770">/).strip()
            puts content
            url.new_content1=content
            #puts content
            #这里是否应该增加一个标识用来说明已经抽取过图片了，如果没有这个标识，那么必须一次性等上一步，extract_content的详细页都下载完成了再一次性执行
            url.save
            images=content.scan(/<img[\s\S]*?src=("|')([^\1]*?)\1/i)
            #images.uniq! unless images.nil?
            #puts images
            #puts images.class
            #pp images
            #[["\"", "images/upload/month_1101/201101150853162517.jpg"]]
            images.each do |elems|
                #puts elems
                #pp elems
                img_url=elems[1].strip
                #puts img_url
                image=Image.new
                image.url_id=url.id
                image.img_url=img_url
                image.site="俏货"
                image.kind="image"
                image.save#这里有一个问题是如果半途中断，会重新new一个新的，要不就得重来
                #有一些产品在主体中确实只有文字没有图片的，怎么办？我们这里就不对它进行录入了
            end
            puts "image count:"+images.size.to_s
        end
    end
    
    desc "抽取大图"
    task :extract_big_img => :environment do
        Url.find_each(:conditions=>"kind='detail' and site ='俏货' and success=1") do |url|
        #Url.where(:kind=>"detail").where(:site=>"俏货").where(:success=>true).all.each do |url|
        #[Url.where(:kind=>"detail").where(:site=>"俏货").where(:success=>true).first].each do |url|
            puts url.myurl
            html=url.content
            puts "==========================="
            content=html.get_part(:s=>%Q{"},:e=>%Q{" id="aa"},:left=>false).strip
            puts content

            if content.blank? ==false and content.nil? ==false
                image=Image.new
                image.url_id=url.id
                image.img_url=content
                image.site="俏货"
                image.kind="image"
                image.big=true
                image.save
            end
            #images=content.scan(/<img[\s\S]*?src=("|')([^\1]*?)\1/i)
            ##[["\"", "images/upload/month_1101/201101150853162517.jpg"]]
            #images.each do |elems|
            #    img_url=elems[1].strip
            #    puts img_url
            #    image=Image.new
            #    image.url_id=url.id
            #    image.img_url=img_url
            #    image.site="俏货"
            #    image.kind="image"
            #    image.big=true
            #    image.save
            #end

        end
    end
    
    desc "图片下载"
    task :image_down => :environment do
        while Image.where(:kind=>"image").where(:site=>"俏货").where(:success=>false).where(:failure=>false).count >0
            puts "新一轮"
            Image.find_each(:conditions=>"site='俏货' and success=0 and kind='image' and failure=0") do |image|
            #[Image.where(:kind=>"image").where(:site=>"俏货").where(:success=>false).first].each do |image|
            #Image.where(:kind=>"image").where(:site=>"俏货").where(:success=>false).all.each do |image|
            #Image.where(:id=>6122).all.each do |image|
                begin#以后图片下载使用md5后的值做为文件名，长就长点，避免问题
                    url=image.img_url
                    unless url=~/^http:/
                        require 'uri'
                        url=URI.join("http://www.92pifa.com",URI.escape(image.img_url)).to_s
                    else
                        url=URI.escape(image.img_url)
                    end
                    puts url
                    fullpath=""
                #begin
                    filename=url.split("/").last
                    a,b=filename.split(".")
                    #filename="#{Time.now.strftime("%Y%m%d%H%M%S")}_#{rand(1000)}"+"."+url.split("/").last.split(".")[1]
                    filename=Digest::MD5.hexdigest(a)+"."+b
                    fullpath="./crawler/qh/images/#{filename}"
                    if File.exist?(fullpath)
                        puts filename+"已经存在了"
                        #require 'uuid'
                        #filename=UUID.new.generate.to_s+"."+filename.split(".").last
                    else
                        url_str = URI.parse(url)
                        site = Net::HTTP.new(url_str.host, url_str.port)
                        site.open_timeout = 10
                        site.read_timeout = 10
                        path = url_str.query.blank? ? url_str.path : url_str.path+"?"+url_str.query
                        resp = site.get(path)
                        #resp=site.get2(path,{'accept'=>'text/html','user-agent'=>'Mozilla/5.0'})
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
                  puts "--=========-"
                  image.try_times+=1
                  if image.try_times >= 3
                    image.failure=true
                  end
                  image.save
                  begin
                    if File.exist?(fullpath)
                      File.delete(fullpath)
                    end
                  rescue Exception => ex
                    puts ex
                  end
                end
            end
            #sleep(20)
        end
    end

    desc "bmp to jpg,由于bmp太大"
    task :bmp_to_jpg => :environment do
        Image.find(:all,:conditions=>"kind='image' and site ='俏货' and success=1 and new_img_url like '%.bmp'").each do |myimage|
        #[Image.find(:first,:conditions=>"kind='image' and site ='俏货' and success=1 and new_img_url like '%.bmp'")].each do |myimage|
            begin
                path="./crawler/qh/images/#{myimage.new_img_url}"
                new_path=path[0..-5]+".jpg"
                puts new_path
                img=MiniMagick::Image.from_file path
                img.format("jpg")
                img.write(new_path)
                myimage.new_img_url=new_path.split("/").last
            rescue Exception => ex
                myimage.failure = true
                myimage.success = false
                puts ex
                puts "置为failure"
            ensure
                myimage.save
            end
                
        end
    end
    
    desc "检测图片是否真的下载完成了,执行前去图片目录下删除一些没有用的图片"
    task :image_down_success? => :environment do
        filename="201101150853162517.jpg"
        #puts File.exist?("./crawler/wk/images/#{filename}")
        #return nil
        puts "---"
        count=0
        Image.find_each(:conditions=>"kind='image' and site ='俏货' and success=1") do |image|
        #Image.where(:kind=>"image").where(:site=>"俏货").where(:success=>true).all.each do |image|
            path="./crawler/qh/images/#{image.new_img_url}"
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
    
    


    desc "抽取其它信息"
    task :extract_others => :environment do
        Url.find_each(:conditions=>"kind='detail' and site ='俏货' and success=1") do |url|
        #Url.where(:kind=>"detail").where(:site=>"俏货").where(:success=>true).all.each do |url|
        #[Url.where(:kind=>"detail").where(:site=>"俏货").where(:success=>true).first].each do |url|
            puts url.myurl
            html=url.content
            puts "==========================="

            name=html.get_part(:s=>%Q{商品名称},:e=>%Q{[}).filter_tags.filter_characters.strip
            puts "商品名称:"+name
            shortname=html.get_part(:s=>%Q{商品简称},:e=>%Q{[}).filter_tags.filter_characters.strip
            puts "商品简称:"+shortname
            size=html.get_part(:s=>%Q{商品尺寸},:e=>%Q{[}).filter_tags.filter_characters.strip
            puts "商品尺寸:"+size
            weight=html.get_part(:s=>%Q{单个重量},:e=>%Q{[}).filter_tags.filter_characters.strip
            puts "商品重量:"+weight
            material=html.get_part(:s=>%Q{商品材质},:e=>%Q{[}).filter_tags.filter_characters.strip
            puts "商品材质:"+material
            wrap=html.get_part(:s=>%Q{商品包装},:e=>%Q{[}).filter_tags.filter_characters.strip
            puts "商品包装:"+wrap
            price=html.get_part(:s=>%Q{批发价},:e=>%Q{您的价格}).filter_tags.filter_characters.strip.filter_price.strip
            puts "商品价格:"+price
            unit=html.get_part(:s=>%q{商品单位},:e=>%Q{[}).filter_tags.filter_characters.strip
            puts "商品单位:"+unit
            location=html.get_part(:s=>%q{商品产地},:e=>%Q{[}).filter_tags.filter_characters.strip
            puts "商品产地:"+location
            package=html.get_part(:s=>%q{装箱数量},:e=>%Q{[}).filter_tags.filter_characters.strip
            puts "装箱数量:"+package
            url.name=name
            url.shortname=shortname
            url.size=size
            url.weight=weight
            url.material=material
            url.wrap=wrap
            stock=html.get_part(:s=>%q{现货数量},:e=>%Q{[}).filter_tags.filter_characters.strip
            if stock.blank? ==false and stock.nil? ==false and stock.index("此货暂缺").nil? ==true
                url.stock=true
                puts "有货"
            else
                url.stock=false
                puts "缺货"
            end
            url.location=location
            url.unit=unit
            url.package=package
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
    

    
    desc "对于在主体中没有图片的商品,即在Images中没有记录的产品，设置该产品success=false，不上架"
    task :set_failure_for_no_pic_on_content => :environment do
        url_ids_in_images=Image.find_by_sql("select distinct url_id from images where site='俏货' and kind='image' and big=0").map{|image| image.url_id}.to_set
        puts url_ids_in_images.size
        
        url_ids_in_urls=Url.where(:kind=>"detail").where(:site=>"俏货").where(:success=>true).all(:select=>:id).map{|url| url.id}.to_set
        puts url_ids_in_urls.size
        r=(url_ids_in_urls-url_ids_in_images).to_a
        puts r.size
        puts "effect number:" + Url.update_all({:success=>false},:id=>r).to_s

    end
    
    desc "对于在主大图片的商品,即在Images中没有big=true记录的产品，设置该产品success=false，不上架"
    task :set_failure_for_no_big_pic => :environment do
        url_ids_in_images=Image.find_by_sql("select distinct url_id from images where site='俏货' and kind='image' and big=1").map{|image| image.url_id}.to_set
        puts url_ids_in_images.size
        
        url_ids_in_urls=Url.where(:kind=>"detail").where(:site=>"俏货").where(:success=>true).all(:select=>:id).map{|url| url.id}.to_set
        puts url_ids_in_urls.size
        r=(url_ids_in_urls-url_ids_in_images).to_a
        puts r.size
        puts "effect number:" + Url.update_all({:success=>false},:id=>r).to_s
    end
    
    desc "上传图片"
    task :upload => :environment do
            #r=RestClient.post 'http://www.geilibuy.com/kindeditor/upload', :imgFile => File.new("/home/mlzboy/my/b2c2/public/themes/default/imgs/rm.png", 'rb')
            #pp r
        Image.find_each(:conditions=>"site='俏货' and success=1 and big=0") do |image|
        #Image.where(:kind=>"image").where(:site=>"俏货").where(:success=>true).where(:big=>false).all.each do |image|
        
            #r=RestClient.post 'http://www.geilibuy.com/kindeditor/upload', :imgFile => File.new("/home/mlzboy/my/b2c2/public/themes/default/imgs/rm.png", 'rb')
            r=RestClient.post 'http://www.geilibuy.com/kindeditor/upload', :imgFile => File.new("./crawler/qh/images/#{image.new_img_url}", 'rb')
            pp r
            parsed_json = ActiveSupport::JSON.decode(r)
            url=parsed_json["url"]
            idx=url.rindex("?")
            if idx
                url=url[0...idx]
            end
            #以后还要关联上kindeditor对应记录行的id,及是否uploaded
            puts url
            image.real_img_url=url
            image.save
        end
    end
    desc "替换图片链接"
    task :replace_img_url => :environment do
        #urls=[Url.where(:kind=>"detail").where(:site=>"俏货").where(:success=>true).first].each do |url|
        Url.find_each(:conditions=>"kind='detail' and site='俏货' and success=1") do |url|
        #Url.where(:kind=>"detail").where(:site=>"俏货").where(:success=>true).all.each do |url|
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
            else
                url.success=false
                url.save
            end
        end
    end
    desc "tojson"
    task :test_json => :environment do
        
    end
    
    desc "添加产品"
    task :batch_add_products => :environment do
        #[Url.where(:kind=>"detail").where(:site=>"俏货").where(:success=>true).where(:upload=>false).first].each do |url|
        #Url.where(:kind=>"detail").where(:site=>"俏货").where(:success=>true).all.each do |url|
        Url.find_each(:conditions=>"kind='detail' and site='俏货' and success=1 and upload=0") do |url|
            #r=RestClient.post 'http://www.geilibuy.com/admin/product/create', :imgFile => File.new("/home/mlzboy/my/b2c2/public/themes/default/imgs/rm.png", 'rb')
    
            server_url="http://www.geilibuy.com/admin/products"
            dict={}
            dict["utf8"]="✓"
            dict["authenticity_token"]="Vbvepv/f/AvGc7K2yvICaP2LrhKjrAId/BdSJEg12iI="
            dict["category_id"]=["1"]
            dict["brand_id"]=""

            dict["url_id"]=url.id.to_s
            product={}
            count=0
            url.images.find_all{|elem| elem.big==true and elem.success==true}.each_with_index do |image,index|
                count+=1
                idx=index+1
                if idx<5
                    product["i#{idx}"]=File.new("./crawler/qh/images/#{image.new_img_url}", 'rb')
                end
            end
            if count==0
                puts "没有big pic ,go next"
                next
            end
            if url.shortname.blank? or url.shortname.nil?
                product["name"]=url.name
            else
                product["name"]=url.shortname
            end
            product["sub_title"]=""
            product["p1"]=(url.price*2.2).price_truncate
            product["p2"]=(url.price*1.2).price_truncate
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
            product["material"]=url.material
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
            product["href_name"]=url.href_name
            product["url_id"]=url.id.to_s
            dict["product"]=product
            dict["commit"]="Create Product"
            RestClient.post(server_url,dict)
            url.upload=true
            url.save
        end
    
    end
    
    desc "下加产品表的描述中带有俏货字眼的产品"
    task :off_products_with_forbiden_characters => :environment do
        count=0
        Product.description_like("%俏货%").each do |product|
            product.on=false
            product.save(:validate=>false)
            count+=1
        end
        puts "effect nums:"+count.to_s
    end
end