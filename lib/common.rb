#coding:utf-8
class ::String
    #将非绝对图片路径转换为绝对
    def img_to_absolute_path(url="http://www.geilibuy.com")
        require 'uri'
        images=self.scan(/<img[\s\S]*?src=("|')([^\1]*?)\1/i)
        r=self
        images.each do |elems|
            unless elems[1]=~/^http/i
                new_url=URI.join(url,elems[1]).to_s
                r.sub!(elems[1],new_url)
            end
        end
        return r
    end
end