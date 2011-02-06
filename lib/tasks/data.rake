#coding:utf-8
desc "将lucky值更新到10"
task :update_lucky => :environment do
    Product.find_each do |product|
        unless product.lucky>0
            product.lucky=10
            product.save(:validate=>false)
        end
    end
end

desc "dddd"
task :update_special_characters => :environment do
    Product.name_like("%'%").each do |product|
        product.name=product.name.gsub("'","‘")
        product.save(:validate=>false)
    end
end
class ::String
    #将非绝对图片路径转换为绝对
    def img_to_absolute_path(url)
        require 'uri'
        images=self.scan(/<img[\s\S]*?src=("|')([^\1]*?)\1/i)
        r=self
        images.each do |elems|
            unless elems[1]=~/^http/i
                new_url=URI.join("http://www.geilibuy.com",elems[1]).to_s
                r.sub!(elems[1],new_url)
            end
        end
        return r
    end
end

desc "test img replace to absolute path"
task :img_replace_to_absolute_path_test do
    a=%Q{
<td style="padding-right: 0px; padding-left: 0px; font-weight: normal; font-size: 14px; padding-bottom: 10px; color: rgb(0,0,0); line-height: 22px; padding-top: 10px">
            <p><img src="/system/uploads/000/029/263/original/2(5).jpg?1296820358" alt="" border="0" /></p>
<p><meta http-equiv="content-type" content="text/html; charset=utf-8"><span class="Apple-style-span" style="font-family:Tahoma,����,Arial,Helvetica,sans-serif;line-height:22px;font-size:14px;"><strong>白色</strong>的兔兔帽采用<strong>优质羊羔绒</strong>，<strong>保暖舒适</strong>，不用的时候<strong>可以叠成一只超级可爱的兔子</strong>，绝对是送MM的最佳礼物~~~</span></p>

<p><span class="Apple-style-span" style="font-family:Tahoma,����,Arial,Helvetica,sans-serif;line-height:22px;font-size:14px;"><img src="/system/uploads/000/029/264/original/1.jpg?1296910467" alt="" border="0" /><br />
</span></p>

    }
    puts a.img_to_absolute_path("http://www.geilibuy.com")
end