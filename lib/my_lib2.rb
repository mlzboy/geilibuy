#coding:utf-8

module MyLib2
  def build_pre2(current_page,productid,value)
    if current_page==1
      r='<span><font>«首页</font></span><span><font>­上一页</font></span>'
    else
      a="<span><a onclick=\"get_pl(#{productid}, #{1}, 1,#{value})\" href=\"#comments\">«首页</a></span>"
      b="<span><a onclick=\"get_pl(#{productid}, #{current_page-1}, 1,#{value})\" href=\"#comments\">上一页</a></span>"
      r=a+b
    end
    r='<div class="page_box">'+r
  end

  def build_post2(current_page,total_pages,productid,value)
    if current_page==total_pages
      r='<span><font>­下一页</font></span><span><font>尾页»</font></span>'
    else
      a="<span><a onclick=\"get_pl(#{productid}, #{current_page+1}, 1,#{value})\" href=\"#comments\">下一页</a></span>"
      b="<span><a onclick=\"get_pl(#{productid}, #{total_pages}, 1,#{value})\" href=\"#comments\">尾页»</a></span>"
      r=a+b
    end
    r+="<span><font>#{current_page}/共#{total_pages}页</font></span> </div>"
  end

  def build_link2(page,productid,value,current_page)
    if page!=current_page
      "<span><a onclick=\"get_pl(#{productid}, #{page}, 1,#{value})\" href=\"#comments\">#{page}</a></span>"
    else
      "<span id=\"page_on\"><font>#{page}</font></span>"
    end
  end

  def gen_page_html2(current_page,total_pages,productid,value)
    body=""
    (1..total_pages).each do |page|
      body+=build_link2(page,productid,value,current_page)
    end
    pre=build_pre2(current_page,productid,value)
    post=build_post2(current_page,total_pages,productid,value)
    pre+body+post
  end



end


