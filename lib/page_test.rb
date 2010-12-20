#coding:utf-8
total_pages=11
current_page=10

a=(1..total_pages).to_a
 
if total_pages>6
  if current_page-5>0
    if current_page+2<=total_pages
      a.delete_if{|x| x< current_page-2}
    elsif current_page+1<=total_pages
      a.delete_if{|x| x<current_page-3}
    elsif current_page<=total_pages
      a.delete_if{|x| x<current_page-4}
    end
  end
  if current_page+5>0
    if current_page-2>0
      a.delete_if{|x| x >current_page+2}
    elsif current_page-1>0
      a.delete_if{|x| x>current_page+3}
    elsif current_page>0
      a.delete_if{|x| x>current_page+4}
    end
  end
end
if a.first!=1
  a.unshift "..."
  a.unshift 1
end
if a.last!=total_pages
  a<<"..."
  a<<total_pages
end
puts a
puts "----------"
pos=a.index(current_page)
def gen_link(page)
  page=page.to_s
  #拼接样式输出
  %Q{<span><a href="">#{page}</a></span>}
end

r=[]
a.each_with_index do |elem,index|
  page=elem
  if elem=="..." and index<pos
    page=a[a.index("...")+1]-1
  end
  if elem=="..." and index>pos
    page=a[a.rindex("...")-1]+1
  end
  r<<gen_link(page)
end

#修改当前页的样式
r[pos]=%Q{<span id="page_on"><font>#{a[pos]}</font></span>}
if current_page==1
  r.unshift %q{<span><font>&#173;上一页</font></span>}
  r.unshift %q{<span><font>&laquo;首页</font></span>}
  r.unshift %q{<div class="page_box">}
else
  page=current_page-1
  r.unshift %Q{<span><a href="">上一页</a></span>}
  r.unshift %Q{<span><a href="">首页</a></span>}
  r.unshift %q{<div class="page_box">}
end
if current_page==total_pages
  r<<%q{<span><a href="">&#173;下一页</a></span>}
  r<<%q{<span><a href="" >&#173;尾页&raquo;</a></span>}
  r<<%q{<span><font>1/共11页</font></span>}
  r<<%q{</div>}
else
  page=current_page+1
  r<< %Q{<span><a href="">&#173;下一页</a></span>}
  r<< %Q{<span><a href="">&#173;尾页&raquo;</a></span>}
  r<<%q{</div>}

end
puts r
puts r.join("")
  
  
