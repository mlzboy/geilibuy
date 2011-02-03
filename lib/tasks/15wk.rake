#coding:utf-8
#require 'typhoeus'
require 'net/http'
require 'pp'
require 'nokogiri'  
require 'uri'
require 'set'
ENV['RAILS_ENV'] ||= "production"

puts  Dir.pwd
class ::Float
    def price_truncate
        price=self
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
end
class ::String
    require 'iconv'
    #Conv=Iconv.new('utf-8','gbk')
    Conv=Iconv.new("GBK//IGNORE","UTF-8//IGNORE")
    Conv2=Iconv.new("UTF-8//IGNORE","GB18030//IGNORE")

    
    def to_utf8
        Conv.iconv(self)
    end
    
    def to_gbk
        Conv2.iconv(self)
    end

  def filter_tags(tags=["em","dd","input","h1","h2","h3","br","a","b","span","strong","p","hr","strong","p","hr","font","div","td","tr","img","form","table"])
    tags.each do |elem|
      self.gsub!(/<#{elem}[\s\S]*?>/i,"")
      self.gsub!(/<\/ *#{elem}[\s\S]*?>/i,"")
    end
    self
  end
  def filter_characters(tags=["￥"," ","]","："])
    tags.each do |elem|
      self.gsub!(elem,"")
    end
    self
  end
  def filter_comments()
    self.gsub!(/<!--[\s\S]*?-->/m,'')
  end
  def filter_int()
    self.gsub!(/[^\d]+/m,'')
    begin
      self.to_i.to_s
    rescue
      "0"
    end
  end
  def filter_price()
    self.gsub!(/[^\d\.]*/m,'').chomp!
    begin
        return self.to_f.to_s
    rescue
        return "0"
    end
  end
  
  def find_tag_idx(tag,count=1)
    #html=html.to_s
    html=self
    current_count=0
    idx=0
    start=0
    #puts "==========="
    #puts count
    #puts current_count
    while current_count < count
      idx=html.index(tag,start)
      unless idx.nil?
        current_count+=1
        if tag.class==String
          start=idx+tag.length
        else
          start=idx+html[start..-1].slice(tag).length
        end
      else
        break
      end
    end
    r=unless idx.nil?
      idx..start-1
    else
      nil  
    end
  end
  
  def rfind_tag_idx(tag,count=1)
    #html=html.to_s
    html=self
    current_count=0
    idx=0
    start=html.length
    #puts "==========="
    #puts start
    #puts count
    #puts current_count
    l=-1
    while current_count < count
      idx=html.rindex(tag,start)
      #puts ">>>>>"
      #puts idx
      unless idx.nil?
        current_count+=1
        start=idx-1
        if tag.class==String
          l=tag.length
        else
          l=html.scan(tag).reverse[current_count-1]
          if l.nil?
            l=0
          else
            l=l.length
          end
        end
      else
        break
      end
    end
    #puts "lllllllllllllllllllll"
    #puts l
    r=if (idx.nil? or l<1)
      nil
    else
      idx..idx+l-1
    end
  end
#left=false时,s还是从左边起始算，e为右边起始的算，在内部算时先算e这边，再推到左边过来
  def get_part(real)
    args={:s=>nil,:e=>nil,:s_count=>1,:e_count=>1,:left=>true}
    args.merge! real
    require 'pp'
    #pp args
    if args[:left]
        html=self
        r=""
        if html.nil?
          return ""
        else
          html=html.to_s
        end
        _html=html
        if args.length==0
          return _html
        else
          s=0
          e=-1
          unless args[:s].nil?
    
            s_range=_html.find_tag_idx(args[:s],args[:s_count])
    
            if s_range.nil?
              return ""
            else
            #puts "s_range"
            #puts _html[s_range]
              s=s_range.last+1
              _html=_html[s..-1]
              #puts _html
            end
          end
          unless args[:e].nil?
            #puts "--------------------------------"
            #puts args[:e],args[:e_count]
            #puts _html
            e_range=_html.find_tag_idx(args[:e],args[:e_count])
    
            if e_range.nil? or e_range==(0..0)
              return ""
            else
            #puts "e_range"
            #puts _html[e_range]
            #puts e_range
              e=e_range.first-1
            end
          end
          #puts "s==>"
          #puts s
          #puts "e==>"
          #puts e
          #puts "dddddddddddddddddddd"
          return _html[0..e]
        end
    else
      #puts "rightTTTTTTTTTTTTTTTTTTTT"
        html=self
        r=""
        if html.nil?
          return ""
        else
          html=html.to_s
        end
        _html=html
        if args.length==0
          return _html
        else
          s=0
          e=-1
          unless args[:e].nil?
            #puts "--------------------------------"
            #puts args[:e],args[:e_count]
            #puts _html
            e_range=_html.rfind_tag_idx(args[:e],args[:e_count])
    
            if e_range.nil?# or e_range==(0..0)
              return ""
            else
            #puts "e_range"
            #puts _html[e_range]
            #puts e_range
              e=e_range.first-1
              _html=_html[0..e]
              #puts _html
            end
          end
          unless args[:s].nil?
    
            s_range=_html.rfind_tag_idx(args[:s],args[:s_count])
    
            if s_range.nil?
              return ""
            else
            #puts "s_range"
            #puts _html[s_range]
            #puts s_range
              s=s_range.last+1
              #puts _html
            end
          end
          #puts "s==>"
          #puts s
          #puts "e==>"
          #puts e
          #puts "dddddddddddddddddddd"
          return _html[s..-1]
        end
    end
  end
  
end



namespace :wk do
    desc "获取万客全部商品页面中的各分类链接及其名称"
    task :get_category_links => :environment do
        url="http://www.15wk.com/prolist---0----/"
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
            u.site="万客"
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
        u=Url.where(:site=>"万客").where(:kind=>"index").first
        html=u.content
        tags=["ul","em","dd","input","h1","h2","h3","br","b","span","strong","p","hr","strong","p","hr","font","div","td","tr","img","form","table"]
        #过滤掉除了<a href="/prolist-b-30-0----/" class="progo">节日专区</a>形式之外的所有内容，只留链接
        content=html.get_part(:s=>%Q{<div class="about_left_class">},:e=>%Q{<div style="width:235px;">}).filter_tags(tags).strip()
        #提取链接地址和名称        
        arrs=content.scan(/<a[\s\S]*?href=("|')([\s\S]*?)\1[\s\S]*?>([\s\S]*?)<[\s\S]*?a[\s\S]*?>/)
        arrs.each do |r| 
            url=r[1]
            name=r[2]
            unless url=~/^http:/
                url=URI.join("http://www.15wk.com",URI.escape(url)).to_s
            else
                url=URI.escape(url)
            end
            puts url
            puts name

            u=Url.find_by_myurl(url)
            u=Url.new unless u
            u.site="万客"
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
        firsts=Url.where(:site=>"万客").where(:kind=>"first").where(:success=>false).all
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
    desc "download all next kind page"
    task :down_all_next_pages => :environment do
        firsts=Url.where(:site=>"万客").where(:kind=>"next").where(:success=>false).all
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
    
    desc "download all product detail pages"
    task :down_all_product_detail_pages => :environment do
        while Url.where(:site=>"万客").where(:kind=>"detail").where(:success=>false).count >0
            puts "新一轮"
            firsts=Url.where(:site=>"万客").where(:kind=>"detail").where(:success=>false).all
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
    
    desc "从extract_topic_first_page_link的页面中抽取各该专题剩余的链接"
    task :extract_topic_left_page_links => :environment do
        firsts=Url.where(:site=>"万客").where(:kind=>"first").where(:success=>true).all
        #firsts=[firsts.first]
        firsts.each do |first|
            html=first.content#专题第一页的内容
            #找出这个专题所有的列表页面链接
            #共<font color="#FF0000"><strong>9</strong></font>页
            pages=html.get_part(:s=>%q{共<font color="#FF0000"><strong>},:e=>%q{</strong></font>页}).strip.to_i
            
            puts pages
            if pages>1
                (2..pages).each do |page|
                    url=first.myurl[0..-2]+page.to_s+"/"
                    puts url
                    u=Url.find_by_myurl(url)
                    u=Url.new unless u
                    u.site="万客"
                    u.myurl=url
                    #u.success=true
                    u.kind="next"#第一页
                    #u.parent_ids=u.id.to_s
                    u.href_name=first.href_name
                    u.save
                end
            end
            
        end
    end
    
    desc "extract product detail page links"
    task :extract_product_detail_page_links => :environment do
        #从各个列表页抽取详细页面的链接
        #lists=Url.find_by_sql("select * from urls where success=1 and (kind='first' or kind='next') and site='万客' limit 0,1")
        lists=Url.find_by_sql("select * from urls where success=1 and (kind='first' or kind='next') and site='万客'")
        lists.each do |list|
            puts list.myurl
            #<a href="/ShowPro15090.html" title="【秒杀】时尚大叶子花贝雷帽围巾两件套(混色)促销" target="_blank"><img src="http://www.cpzy123.com/pro_s/2010-4/2010421451373625.jpg" width="164" height="164" border="0"></a>
            list.content.scan(/<a href=("|')(\/ShowPro\d*\.html)\1[\s\S]*?<img[\s\S]*?<\/a>/) do |r|
                puts r[1]
                _url=URI.join("http://www.15wk.com",r[1]).to_s
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
                    u.site="万客"
                end
                u.save
            end
        end
    end
    
    desc "抽取产品详细页中的主体部分的内容到urls#new_content1中,并将内容中的image放到images表中"
    task :extract_content => :environment do
        #urls=[Url.where(:kind=>"detail").where(:site=>"万客").where(:success=>true).first].each do |url|
        Url.where(:kind=>"detail").where(:site=>"万客").where(:success=>true).all.each do |url|
            puts url.myurl
            html=url.content
            content=html.get_part(:s=>/<tr style="display:" id="go1">[\s\S]*?;padding:10px;color:#555555;line-height:24px;">/,:e=>/<\/td>[\s\S]*?<\/tr>[\s\S]*?<tr style="display:none" id="go2">/).strip()
            #puts content
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
                image.site="万客"
                image.kind="image"
                image.save
                #有一些产品在主体中确实只有文字没有图片的，怎么办？我们这里就不对它进行录入了
            end
            puts "image count:"+images.size.to_s
        end
    end
    
    desc "图片下载"
    task :image_down => :environment do
        while Image.where(:kind=>"image").where(:site=>"万客").where(:success=>false).where(:failure=>false).count >0
            puts "新一轮"
            Image.find_each(:conditions=>"site='万客' and success=0 and kind='image' and failure=0") do |image|
            #Image.where(:kind=>"image").where(:site=>"万客").where(:success=>false).all.each do |image|
            #Image.where(:id=>6122).all.each do |image|
                begin
                    url=image.img_url
                    unless url=~/^http:/
                        require 'uri'
                        url=URI.join("http://www.15wk.com",URI.escape(image.img_url)).to_s
                    else
                        url=URI.escape(image.img_url)
                    end
                    
                    fullpath=""
                #begin
                    filename=url.split("/").last
                    fullpath="./crawler/wk/images/#{filename}"
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
            sleep(20)
        end
    end
    
    desc "抽取大图"
    task :extract_big_img => :environment do
        Url.find_each(:conditions=>"kind='detail' and site ='万客' and success=1") do |url|
        #Url.where(:kind=>"detail").where(:site=>"万客").where(:success=>true).all.each do |url|
        #[Url.where(:kind=>"detail").where(:site=>"万客").where(:success=>true).first].each do |url|
            puts url.myurl
            html=url.content
            puts "==========================="
            content=html.get_part(:s=>%Q{<td width="500" height="500">},:e=>%Q{</td>}).strip
            puts content

            images=content.scan(/<img[\s\S]*?src=("|')([^\1]*?)\1/i)
            #[["\"", "images/upload/month_1101/201101150853162517.jpg"]]
            images.each do |elems|
                img_url=elems[1].strip
                puts img_url
                image=Image.new
                image.url_id=url.id
                image.img_url=img_url
                image.site="万客"
                image.kind="image"
                image.big=true
                image.save
            end

        end
    end

    desc "抽取其它信息"
    task :extract_others => :environment do
        Url.find_each(:conditions=>"kind='detail' and site ='万客' and success=1") do |url|
        #Url.where(:kind=>"detail").where(:site=>"万客").where(:success=>true).all.each do |url|
        #[Url.where(:kind=>"detail").where(:site=>"万客").where(:success=>true).first].each do |url|
            puts url.myurl
            html=url.content
            puts "==========================="

            name=html.get_part(:s=>%Q{商品名称},:e=>%Q{[}).filter_tags.filter_characters.strip
            puts "商品名称:"+name
            size=html.get_part(:s=>%Q{商品尺寸},:e=>%Q{[}).filter_tags.filter_characters.strip
            puts "商品尺寸:"+size
            weight=html.get_part(:s=>%Q{单个重量},:e=>%Q{[}).filter_tags.filter_characters.strip
            puts "商品重量:"+weight
            material=html.get_part(:s=>%Q{商品材质},:e=>%Q{[}).filter_tags.filter_characters.strip
            puts "商品材质:"+material
            wrap=html.get_part(:s=>%Q{商品包装},:e=>%Q{[}).filter_tags.filter_characters.strip
            puts "商品包装:"+wrap
            price=html.get_part(:s=>%Q{批发价格},:e=>%Q{[}).filter_tags.filter_characters.strip.filter_price.strip
            puts "商品价格:"+price
            unit=html.get_part(:s=>%q{商品单位},:e=>%Q{[}).filter_tags.filter_characters.strip
            puts "商品单位:"+unit
            location=html.get_part(:s=>%q{商品产地},:e=>%Q{[}).filter_tags.filter_characters.strip
            puts "商品产地:"+location
            package=html.get_part(:s=>%q{装箱数量},:e=>%Q{[}).filter_tags.filter_characters.strip
            puts "装箱数量:"+package
            url.name=name
            url.size=size
            url.weight=weight
            url.material=material
            url.wrap=wrap
            url.stock=true
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
    
    desc "检测图片是否真的下载完成了"
    task :image_down_success? => :environment do
        filename="201101150853162517.jpg"
        #puts File.exist?("./crawler/wk/images/#{filename}")
        #return nil
        puts "---"
        count=0
        Image.find_each(:conditions=>"kind='image' and site ='万客' and success=1") do |image|
        #Image.where(:kind=>"image").where(:site=>"万客").where(:success=>true).all.each do |image|
            path="./crawler/wk/images/#{image.new_img_url}"
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
    
    desc "对于在主体中没有图片的商品,即在Images中没有记录的产品，设置该产品success=false，不上架"
    task :set_failure_for_no_pic_on_content => :environment do
        url_ids_in_images=Image.find_by_sql("select distinct url_id from images where site='万客' and kind='image' and big=0").map{|image| image.url_id}.to_set
        puts url_ids_in_images.size
        
        url_ids_in_urls=Url.where(:kind=>"detail").where(:site=>"万客").where(:success=>true).all(:select=>:id).map{|url| url.id}.to_set
        puts url_ids_in_urls.size
        r=(url_ids_in_urls-url_ids_in_images).to_a
        puts r.size
        puts "effect number:" + Url.update_all({:success=>false},:id=>r).to_s

    end
    
    desc "对于在主大图片的商品,即在Images中没有big=true记录的产品，设置该产品success=false，不上架"
    task :set_failure_for_no_big_pic => :environment do
        url_ids_in_images=Image.find_by_sql("select distinct url_id from images where site='万客' and kind='image' and big=1").map{|image| image.url_id}.to_set
        puts url_ids_in_images.size
        
        url_ids_in_urls=Url.where(:kind=>"detail").where(:site=>"万客").where(:success=>true).all(:select=>:id).map{|url| url.id}.to_set
        puts url_ids_in_urls.size
        r=(url_ids_in_urls-url_ids_in_images).to_a
        puts r.size
        puts "effect number:" + Url.update_all({:success=>false},:id=>r).to_s
    end
    
    desc "上传图片"
    task :upload => :environment do
            #r=RestClient.post 'http://www.geilibuy.com/kindeditor/upload', :imgFile => File.new("/home/mlzboy/my/b2c2/public/themes/default/imgs/rm.png", 'rb')
            #pp r
        Image.find_each(:conditions=>"site='万客' and success=1 and big=0") do |image|
        #[Image.find(:first,:conditions=>"site='万客' and success=1 and big=0")].each do |image|
        #Image.where(:kind=>"image").where(:site=>"万客").where(:success=>true).where(:big=>false).all.each do |image|
        
            #r=RestClient.post 'http://www.geilibuy.com/kindeditor/upload', :imgFile => File.new("/home/mlzboy/my/b2c2/public/themes/default/imgs/rm.png", 'rb')
            r=RestClient.post 'http://www.geilibuy.com/kindeditor/upload', :imgFile => File.new("./crawler/wk/images/#{image.new_img_url}", 'rb')
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
    end
    desc "替换图片链接"
    task :replace_img_url => :environment do
        #urls=[Url.where(:kind=>"detail").where(:site=>"万客").where(:success=>true).first].each do |url|
        Url.find_each(:conditions=>"kind='detail' and site='万客' and success=1") do |url|
        #Url.where(:kind=>"detail").where(:site=>"万客").where(:success=>true).all.each do |url|
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
        #[Url.where(:kind=>"detail").where(:site=>"万客").where(:success=>true).first].each do |url|
        #Url.where(:kind=>"detail").where(:site=>"万客").where(:success=>true).all.each do |url|
        Url.find_each(:conditions=>"kind='detail' and site='万客' and success=1") do |url|
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
                    product["i#{idx}"]=File.new("./crawler/wk/images/#{image.new_img_url}", 'rb')
                end
            end
            if count==0
                puts "没有big pic ,go next"
                next
            end
            product["name"]=url.name
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
        end
    
    end
    
    desc "下加产品表的描述中带有万客字眼的产品"
    task :off_products_with_forbiden_characters => :environment do
        Product.description_like("%万客%").each do |product|
            product.on=false
            product.save(:validate=>false)
        end
    end
    
    desc "下加产品表的描述中带有万客字眼的产品"
    task :off_products_with_forbiden_characters_taobao => :environment do
        Product.description_like("%淘宝%").each do |product|
            product.on=false
            product.save(:validate=>false)
        end
    end    
end