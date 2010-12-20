#coding:utf-8
module MyLib4
  def build_pre4(current_page,productid,value)
    if current_page==1
      r='<span><font>«首页</font></span>  <span><font>­上一页</font></span>  '
    else
      a="<span><a href=\"?page=1\">«首页</a></span>  "
      b="<span><a href=\"?page=#{current_page-1}\">上一页</a></span>  "
      r=a+b
    end
    r='<div class="page_box">'+r
  end

  def build_post4(current_page,total_pages,productid,value)
    if current_page==total_pages
      r='  <span><font>­下一页</font></span>  <span><font>尾页»</font></span>'
    else
      a="  <span><a href=\"?page=#{current_page+1}\">下一页</a></span>  "
      b="<span><a href=\"?page=#{total_pages}\">尾页»</a></span>"
      r=a+b
    end
    r+="  <span><font>#{current_page}/共#{total_pages}页</font></span> </div>"
  end

  def build_link4(page,productid,value,current_page)
    if page!=current_page
      "  <span><a href=\"?page=#{page}\">#{page}</a></span>"
    else
      "  <span id=\"page_on\"><font>#{page}</font></span>"
    end
  end

  def gen_page_html4(products,per_page,page)

    if products.size>0
      per_page=per_page.to_i
      page=page.to_i
      total_pages=products.size/per_page + (products.size%per_page ==0 ? 0 : 1)
      page=page%total_pages
      page=total_pages if page==0
      current_page=page
      productid=""
      value=""
      one_page_products=products[per_page*(current_page-1),per_page]
      #current_page,total_pages,productid,value=articles.current_page,articles.total_pages,"",""
    else
      current_page,total_pages,productid,value=1,1,"",""
      one_page_products=[]
    end

    body=""
    (1..total_pages).each do |page|
      body+=build_link4(page,productid,value,current_page)
    end
    pre=build_pre4(current_page,productid,value)
    post=build_post4(current_page,total_pages,productid,value)
    [one_page_products,pre+body+post]
  end



end
#include MyLib4
#products=[1,2,3,4,5,6,7,8,9]
#@products,@page=MyLib4::gen_page_html2(products,3,1)
#puts @products
#puts @page
