#coding:utf-8
#<a onclick="get_pl(9909, 1, 1,0)" href="#comments">1</a>
module MyLib3
  def build_pre3(current_page,productid,value)
    if current_page==1
      r='<span><font>«首页</font></span>  <span><font>­上一页</font></span>  '
    else
      a="<span><a href=\"?page=1\">«首页</a></span>  "
      b="<span><a href=\"?page=#{current_page-1}\">上一页</a></span>  "
      r=a+b
    end
    r='<div class="page_box">'+r
  end

  def build_post3(current_page,total_pages,productid,value)
    if current_page==total_pages
      r='  <span><font>­下一页</font></span>  <span><font>尾页»</font></span>'
    else
      a="  <span><a href=\"?page=#{current_page+1}\">下一页</a></span>  "
      b="<span><a href=\"?page=#{total_pages}\">尾页»</a></span>"
      r=a+b
    end
    r+="  <span><font>#{current_page}/共#{total_pages}页</font></span> </div>"
  end

  def build_link3(page,productid,value,current_page)
    if page!=current_page
      "  <span><a href=\"?page=#{page}\">#{page}</a></span>"
    else
      "  <span id=\"page_on\"><font>#{page}</font></span>"
    end
  end

  def gen_page_html3(articles)
    if articles.size>0
      current_page,total_pages,productid,value=articles.current_page,articles.total_pages,"",""
    else
      current_page,total_pages,productid,value=1,1,"",""
    end
    body=""
    (1..total_pages).each do |page|
      body+=build_link3(page,productid,value,current_page)
    end
    pre=build_pre3(current_page,productid,value)
    post=build_post3(current_page,total_pages,productid,value)
    pre+body+post
  end

  def test2()
    r="dd"
    r
  end

end

#include MyLib3
#r=MyLib3::gen_page_html([])
#puts r