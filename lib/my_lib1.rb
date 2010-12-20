#coding:utf-8
module MyLib1
  def build_pre1(current_page,productid,value)
    if current_page==1
      r='<span><font>«首页</font></span><span><font>­上一页</font></span>'
    else
      a="<span><a onclick=\"getcomment(#{productid}, #{1}, 0,#{value})\" href=\"#user_comments\">«首页</a></span>"
      b="<span><a onclick=\"getcomment(#{productid}, #{current_page-1}, 0,#{value})\" href=\"#user_comments\">上一页</a></span>"
      r=a+b
    end
    r='<div class="page_box">'+r
  end

  def build_post1(current_page,total_pages,productid,value)
    if current_page==total_pages
      r='<span><font>­下一页</font></span><span><font>尾页»</font></span>'
    else
      a="<span><a onclick=\"getcomment(#{productid}, #{current_page+1}, 0,#{value})\" href=\"#user_comments\">下一页</a></span>"
      b="<span><a onclick=\"getcomment(#{productid}, #{total_pages}, 0,#{value})\" href=\"#user_comments\">尾页»</a></span>"
      r=a+b
    end
    r+="<span><font>#{current_page}/共#{total_pages}页</font></span> </div>"
  end

  def build_link1(page,productid,value,current_page)
    if page!=current_page
      "<span><a onclick=\"getcomment(#{productid}, #{page}, 0,#{value})\" href=\"#user_comments\">#{page}</a></span>"
    else
      "<span id=\"page_on\"><font>#{page}</font></span>"
    end
  end

  def gen_page_html1(current_page,total_pages,productid,value)
    body=""
    (1..total_pages).each do |page|
      body+=build_link1(page,productid,value,current_page)
    end
    pre=build_pre1(current_page,productid,value)
    post=build_post1(current_page,total_pages,productid,value)
    pre+body+post
  end



end
#include MyLib
#total_pages=1
#current_page=1
#productid=567
#value=0
#include MyLib
#puts MyLib::gen_page_html(current_page,total_pages,productid,value)