#coding:utf-8
require './lib/my_lib1.rb'
require './lib/my_lib2.rb'
require './lib/my_lib3.rb'

include MyLib1
include MyLib2
include MyLib3
class HomeController < ApplicationController
  layout "front"
  def topic
    topic_id=params[:topic_id]
    @topic=Topic.find_by_id(topic_id)
    unless @topic.kind.blank?
      render "topic_full" and return
    end
  end
  def map
    render :layout=>nil
  end
  def share
  end
  def cod_area
    
  end
  def suite
    @product_show=ProductShow.find_by_suite_and_suite_on_and_id(true,true,params[:suite_id])
  end
  #for test
  def convert
    @content=nil
    if request.post?
      unless params[:content].blank?
        @content=params[:content].gsub("http://www.geilibuy.com","http://i2.geilibuy.com")
        logger.debug(@content)
        logger.debug("=====")
      end
    end
    render :layout=>nil
  end
  #start for edm testing
  def consulting_reply
    render 'core_mail/consulting_reply',:layout=>nil
  end
  def coupon_send
    render 'core_mail/coupon_send',:layout=>nil

  end
  def festival_promotion
    render 'core_mail/festival_promotion',:layout=>nil
  end
  def find_password
    render 'core_mail/find_password',:layout=>nil
  end
  def order_confirm
    render 'core_mail/order_confirm',:layout=>nil
  end
  def order_send
    render 'core_mail/order_send',:layout=>nil
  end
  def product_arrival
    render 'core_mail/product_arrival',:layout=>nil
  end
  #end for edm testing
  def advice
  end
  def about
    @article=Article.find_by_id(params[:article_id])
  end
  def helpcenter
    @article=Article.find_by_id(params[:article_id])
  end

  def lottery_list
  end
  def lottery

  end
  def article
    @article=Article.find_by_id(params[:article_id])
  end
  def article_list
    if params[:page].blank?
      page=1
    else
      page=params[:page].to_i
    end
    article_category_id=params[:article_category_id]
    @article_category=ArticleCategory.find_by_id(article_category_id)
    @articles=Article.paginate :conditions=>["article_category_id=?",article_category_id],:order=>"id desc",:per_page=>2,:page=>page
    @page=MyLib3::gen_page_html3(@articles)
  end
  def search
    if params[:page].blank?
      page=1
    else
      page=params[:page].to_i
    end
    sub_category_id=params[:sub_category_id]
    unless sub_category_id.blank?
      ids=Category.find_by_id(sub_category_id).all_children_ids
      sql="select * from products p inner join (SELECT distinct product_id FROM categories_products cp where category_id in (#{ids.join(",")})) cp2 on p.id=cp2.product_id where "
      #sql2="select distinct id,name from brands b inner join (select brand_id from products p inner join (SELECT distinct product_id FROM categories_products cp where category_id in (#{ids.join(",")})) cp2 on p.id=cp2.product_id) p2 on p2.brand_id=b.id"

    else
      sql="select * from products p where "
      #sql2="select * from brands"
    end
    r=[]
    min=params[:min]
    max=params[:max]
    sort=params[:sort]
    brand_id=params[:brand_id]
    keyword=params[:keyword]
    list=[]
    list<<"`on`=1"
    list<<"p2 >= #{min} and p2<= #{max}"  if !min.blank? and !max.blank?
    list<<"p2 >= #{min}"  if !min.blank? and max.blank?
    list<<"p2<=#{max}" if min.blank? and !max.blank?
    list<<"brand_id=#{brand_id}" if !brand_id.blank?
    if !keyword.blank?
      list<<"name like ?"
      r<<"%#{keyword.strip}%"
    end
    sql=sql+" "+list.join(" and ")
    sql2="select distinct b.id,b.name from brands b inner join (#{sql}) s on b.id=s.brand_id"
    if sort.blank?
      sql+=" order by sale,id desc"
    else
      sql+=" order by "+sort+",id desc"
    end
    @products = Product.paginate_by_sql [sql,r],:per_page=>16,:page=>page
    @brands=Brand.find_by_sql [sql2,r]
  end
  def brand
    if params[:page].blank?
      page=1
    else
      page=params[:page].to_i
    end
    brand_id=params[:brand_id]
    min=params[:min]
    max=params[:max]
    sort=params[:sort]
    @brand=Brand.find(brand_id)
    @select_products=@brand.rand_five_products
    sql="select * from products where "
    list=[]
    list<<"`on`=1"
    list<<"p2 >= #{min} and p2<= #{max}"  if !min.blank? and !max.blank?
    list<<"p2 >= #{min}"  if !min.blank? and max.blank?
    list<<"p2<=#{max}" if min.blank? and !max.blank?
    list<<"brand_id=#{brand_id}" if !brand_id.blank?
    sql=sql+" "+list.join(" and ")
    if sort.blank?
      sql+=" order by sale desc,id desc"
    else
      sql+=" order by "+sort+",id desc"
    end
    @products=Product.paginate_by_sql [sql,brand_id],:per_page=>20,:page=>page
  end
  def brands
    category_id=params[:category_id]
    if category_id
      @brands=Category.find_by_id(category_id).brands.reject{|brand| brand.hide==true}
    else
      @brands=Brand.where(:hide=>false).order("position").all
    end
  end
  def score
    if params[:page].blank?
      page=1
    else
      page=params[:page].to_i
    end
    sql="select * from products where `on`=1 and score=1 order by sale desc,id desc"
    @products=Product.paginate_by_sql [sql],:per_page=>20,:page=>page
    @page=MyLib3::gen_page_html3(@products)
  end
  def score_exchange

  end
  def vote
    logger.debug("DFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF")
    logger.debug(params[:options])
    vd=VoteDetail.new
    vd.ip=request.remote_ip
    vd.vote_id=params[:options].to_i
    vd.save
    #render :inline=>'{"error":1,"message":"对不起你已经投过票了!","content":""}'
    render :inline=>'{"error":0,"message":"感谢您,投票成功!","content":""}'
    #render :json=>{"error"=>0,"message"=>"感谢您,投票成功!","content"=>""}
  end
  def index
    @tuan=Tuan.today
    @vote=Vote.top.first
  end
  def gift
    category_id=params[:categoryid]
    if category_id.blank?
      category=Category.find_by_name("礼品")
    else
      category=Category.find_by_id(category_id)
    end
    if params[:page].blank?
      page=1
    else
      page=params[:page].to_i
    end
    sub_category_id=params[:sub_category_id]
    unless sub_category_id.blank?
      ids=Category.find_by_id(sub_category_id).all_children_ids
    else
      ids=category.all_children_ids
    end
    min=params[:min]
    max=params[:max]
    sort=params[:sort]
    brand_id=params[:brand_id]
    sql="select * from products p inner join (SELECT distinct product_id FROM categories_products cp where category_id in (?)) cp2 on p.id=cp2.product_id where "
    list=[]
    list<<"`on`=1"
    list<<"p2 >= #{min} and p2<= #{max}"  if !min.blank? and !max.blank?
    list<<"p2 >= #{min}"  if !min.blank? and max.blank?
    list<<"p2<=#{max}" if min.blank? and !max.blank?
    list<<"brand_id=#{brand_id}" if !brand_id.blank?
    sql=sql+" "+list.join(" and ")
    if sort.blank?
      sql+=" order by sale desc,id desc"
    else
      sql+=" order by "+sort+",id desc"
    end
    @products = Product.paginate_by_sql [sql,ids],:per_page=>16,:page=>page
    sql2="select distinct id,name from brands b inner join (select brand_id from products p inner join (SELECT distinct product_id FROM categories_products cp where category_id in (?)) cp2 on p.id=cp2.product_id) p2 on p2.brand_id=b.id"
    @brands=Brand.find_by_sql [sql2,ids]
  end
  def new
    #category_id=params[:categoryid]
    #category=Category.find_by_id(category_id)
    if params[:page].blank?
      page=1
    else
      page=params[:page].to_i
    end
    sub_category_id=params[:sub_category_id]
    unless sub_category_id.blank?
      ids=Category.find_by_id(sub_category_id).all_children_ids
      sql="select * from products p inner join (SELECT distinct product_id FROM categories_products cp where category_id in (#{ids.join(",")})) cp2 on p.id=cp2.product_id where "
      sql2="select distinct id,name from brands b inner join (select brand_id from products p inner join (SELECT distinct product_id FROM categories_products cp where category_id in (#{ids.join(",")})) cp2 on p.id=cp2.product_id) p2 on p2.brand_id=b.id"

    else
      sql="select * from products p where "
      sql2="select * from ((select distinct brand_id from products p where new=1) p2 inner join brands b on p2.brand_id=b.id)"
    end
    min=params[:min]
    max=params[:max]
    sort=params[:sort]
    brand_id=params[:brand_id]
    list=[]
    list<<"new=1"
    list<<"`on`=1"
    list<<"p2 >= #{min} and p2<= #{max}"  if !min.blank? and !max.blank?
    list<<"p2 >= #{min}"  if !min.blank? and max.blank?
    list<<"p2<=#{max}" if min.blank? and !max.blank?
    list<<"brand_id=#{brand_id}" if !brand_id.blank?
    sql=sql+" "+list.join(" and ")
    if sort.blank?
      sql+=" order by sale,id desc"
    else
      #logger.debug("---------------dddddddddddddddddddddddd")
      #logger.debug(sort)
      sql+=" order by "+sort+",id desc"
    end
    #sql="select * from products p inner join (SELECT distinct product_id FROM categories_products cp where category_id in (?)) cp2 on p.id=cp2.product_id order by id desc"
    @products = Product.paginate_by_sql [sql],:per_page=>16,:page=>page
    #logger.debug("HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH")
    #logger.debug(@products.size)
    #sql2="select distinct id,name from brands b inner join (select brand_id from products p inner join (SELECT distinct product_id FROM categories_products cp where category_id in (?)) cp2 on p.id=cp2.product_id) p2 on p2.brand_id=b.id"
    @brands=Brand.find_by_sql [sql2]
    #logger.debug(@brands.size)
    #logger.debug("ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZz")
    #render 'sub_category' and return
  end
  def promotion#和new代码基本一致
    if params[:page].blank?
      page=1
    else
      page=params[:page].to_i
    end
    sub_category_id=params[:sub_category_id]
    unless sub_category_id.blank?
      ids=Category.find_by_id(sub_category_id).all_children_ids
      sql="select * from products p inner join (SELECT distinct product_id FROM categories_products cp where category_id in (#{ids.join(",")})) cp2 on p.id=cp2.product_id where "
      sql2="select distinct id,name from brands b inner join (select brand_id from products p inner join (SELECT distinct product_id FROM categories_products cp where category_id in (#{ids.join(",")})) cp2 on p.id=cp2.product_id) p2 on p2.brand_id=b.id"

    else
      sql="select * from products p where "
      sql2="select * from ((select distinct brand_id from products p where promotion=1) p2 inner join brands b on p2.brand_id=b.id)"
    end
    min=params[:min]
    max=params[:max]
    sort=params[:sort]
    brand_id=params[:brand_id]
    list=[]
    list<<"promotion=1"
    list<<"`on`=1"
    list<<"p2 >= #{min} and p2<= #{max}"  if !min.blank? and !max.blank?
    list<<"p2 >= #{min}"  if !min.blank? and max.blank?
    list<<"p2<=#{max}" if min.blank? and !max.blank?
    list<<"brand_id=#{brand_id}" if !brand_id.blank?
    sql=sql+" "+list.join(" and ")
    if sort.blank?
      sql+=" order by sale,id desc"
    else
      sql+=" order by "+sort+",id desc"
    end
    @products = Product.paginate_by_sql [sql],:per_page=>16,:page=>page
    @brands=Brand.find_by_sql [sql2]
  end
  def sub_category#已不使用
    if params[:page].blank?
      page=1
    else
      page=params[:page].to_i
    end
    category_id=params[:categoryid]
    category=Category.find_by_id(category_id)
    ids=category.all_children_ids
    sql="select * from products p inner join (SELECT distinct product_id FROM categories_products cp where category_id in (?)) cp2 on p.id=cp2.product_id order by id desc"
    @products = Product.paginate_by_sql [sql,ids],:per_page=>16,:page=>page
    logger.debug("HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH")
    logger.debug(@products.size)
    sql2="select distinct id,name from brands b inner join (select brand_id from products p inner join (SELECT distinct product_id FROM categories_products cp where category_id in (?)) cp2 on p.id=cp2.product_id) p2 on p2.brand_id=b.id"
    @brands=Brand.find_by_sql [sql2,ids]
    logger.debug(@brands.size)
    logger.debug("ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZz")
  end

  def category
    category_id=params[:categoryid]
    category=Category.find_by_id(category_id)
    if category
      if category.top?
        render 'category' and return
      else
        if params[:page].blank?
          page=1
        else
          page=params[:page].to_i
        end
        sub_category_id=params[:sub_category_id]
        unless sub_category_id.blank?
          ids=Category.find_by_id(sub_category_id).all_children_ids
        else
          ids=category.all_children_ids
        end
        min=params[:min]
        max=params[:max]
        sort=params[:sort]
        brand_id=params[:brand_id]
        sql="select * from products p inner join (SELECT distinct product_id FROM categories_products cp where category_id in (?)) cp2 on p.id=cp2.product_id where "
        list=[]
        list<<"`on`=1"
        list<<"p2 >= #{min} and p2<= #{max}"  if !min.blank? and !max.blank?
        list<<"p2 >= #{min}"  if !min.blank? and max.blank?
        list<<"p2<=#{max}" if min.blank? and !max.blank?
        list<<"brand_id=#{brand_id}" if !brand_id.blank?
        sql=sql+" "+list.join(" and ")
        if sort.blank?
          sql+=" order by sale desc"
        else
          sql+=" order by "+sort
        end
        #sql="select * from products p inner join (SELECT distinct product_id FROM categories_products cp where category_id in (?)) cp2 on p.id=cp2.product_id order by id desc"
        @products = Product.paginate_by_sql [sql,ids],:per_page=>16,:page=>page
        logger.debug("HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH")
        logger.debug(@products.size)
        sql2="select distinct id,name from brands b inner join (select brand_id from products p inner join (SELECT distinct product_id FROM categories_products cp where category_id in (?)) cp2 on p.id=cp2.product_id) p2 on p2.brand_id=b.id"
        @brands=Brand.find_by_sql [sql2,ids]
        logger.debug(@brands.size)
        logger.debug("ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZz")
        render 'sub_category' and return
      end
    end
  end

  def product_detail
    product_id=params[:product_id]
    product_id=24 unless product_id
    @product=Product.find(product_id)
    #获取一个产品对应的一组分类，这组分类应该是position为0的一组，返回的结果按分类的从大类到小类排序的数组
    #@whole_categories=[]
    #categories=@product.categories
    #if categories.size>0
    #  category=categories[0]
    #  @whole_categories=category.ancestors.unshift category
    #end
    #@whole_categories=@whole_categories.reverse
    @whole_categories=@product.whole_categories
    #sql=%Q{select ps.* from product_shows ps right join product_shows_products psp on ps.id=psp.product_show_id where suite_on=1 and suite_num=2 and name="关联推荐" and location="产品详细页" and product_id<>#{product_id} limit 0,1}
    #product_shows=ProductShow.find_by_sql(sql)
    product_shows=@product.product_shows.select{|ps| ps.location=="产品详细页" and ps.name=="关联推荐" and ps.suite_num==2 and ps.suite_on==true}
    @product_show=nil
    if product_shows.size>0
      @product_show=product_shows.first
    end
    
    
  end

  def gen_comments(productid,value,page)
    @comments=PresaleConsulting.paginate :per_page=>6,:page=>page,:conditions=>['product_id=? and hide=0 and value=?',productid,value],:order=>["id desc"]
    if @comments.size>0
      html=""
      @comments.each_with_index do |comment,index|
        if comment.user.nil?
          name="匿名"
        else
          name=comment.user.nick
        end
        if (index+1)%2==0
          html+="<div class=\"pl_line gray\"> <ul class=\"zx_zone\"> <li>#{name}:<strong>#{comment.content}</strong><span>[#{comment.created_at.strftime('%Y-%m-%d %H-%M-%S')}]</span></li>"
        else
          html+="<div class=\"pl_line \"> <ul class=\"zx_zone\"> <li>#{name}:<strong>#{comment.content}</strong><span>[#{comment.created_at.strftime('%Y-%m-%d %H-%M-%S')}]</span></li>"
        end
        if !comment.reply.blank?
          html+="<li class=\"re_txt\">#{comment.reply}</li>"
        end
        html+=" </ul> </div>"
      end
      current_page=@comments.current_page
      total_pages=@comments.total_pages
      puts html
      logger.debug("$$$$$$$$$$$$$$$$$$444444444")
      logger.debug(MyLib1::gen_page_html1(current_page,total_pages,productid,value))
      html+=MyLib1::gen_page_html1(current_page,total_pages,productid,value)
    else
      html='<div style="text-align: center;"> <br><br>暂无咨询 </div>'
    end


    result={}
    result["error"]=0
    result["message"]="您的评论已成功发表, 感谢您的参与!"
#      result["content"]=<<HTML
#  <div class="pl_line "> <ul class="zx_zone"> <li>匿名:<strong>感觉这里的产品说明很不详细。我有几个问题，第一、这个灯是否只有usb接线？也就是说这灯是否只能接电脑才能发光？　第二，这灯可否充电后用？</strong><span>[2010-10-15 22:06:03]</span></li> <li class="re_txt">尊敬的给力百货用户您好：有usb接线，接电脑发光，必须一直插着usb接口。</li> </ul> </div> <div class="pl_line gray"> <ul class="zx_zone"> <li>飞过海燃烧:<strong>您好，订单号是2010101039904，可是我无法查询，四天了，怎么还不到，再不来，我不敢保证到时候在这个地方！谢谢合作！给力百货的物品很新奇，但是查询系统狠落后！哎！</strong><span> [2010-10-14 07:16:32]</span></li> </ul> </div> <div class="pl_line "> <ul class="zx_zone"> <li>岚:<strong>按哪里啊？灯体前方有三档吗？怎么按哦？</strong><span> [2010-10-13 13:22:31]</span></li> <li class="re_txt">您好：将电源插入USB接口，按动灯体前方，即可点亮，第一档，夜灯功能，第二档，安眠功能，第三档，关闭。& lt;/li> </ul> </div> <div class="pl_line gray"> <ul class="zx_zone"> <li>cctv:<strong>10月4号订的货，通知说是9号发货了，可是今天还没收到，而且进到网站发现连之前注册的号都没了，害我今天重新注册了</strong><span>[2010-10-12 21:37:50]</span></li> </ul> </div> <div class="pl_line "> <ul class="zx_zone"> <li>yue0126:<strong>这款灯可以自动关闭吗？ 如果可以就太好了！</strong><span>[2010-10-08 11:48:02]</span></li> <li class="re_txt">您好;这款商品不是自动关闭的。</li> </ul> </div> <div class="pl_line gray"> <ul class="zx_zone"> <li>lihenan:<strong>双节如果是免运费就好了</strong><span> [2010-09-23 21:59:01]</span></li> <li class="re_txt">您好，给力百货单张订单满99元会给您免普通快递和货到付款的运费。</li> </ul> </div> <div class="pl_line "> <ul class="zx_zone"> <li>匿名:<strong>广州的一般多少天能寄到啊？</strong><span> [2010-09-19 10:37:23]</span></li> <li class="re_txt">您好！如您订购的商品没有问题给力百货在24小时发货，您的地区3-5个工作日可以送达。请您保持手机的畅通注意查收。</li> </ul> </div> <div class="pl_line gray"> <ul class="zx_zone"> <li>wanwen245965241:<strong>定单2010090562600 都一星期了还没有来。 本来快件是从你们北京发到我们郑州来的。我今天一查跟踪记录，又从郑州发往北京了怎么回事 </strong><span>[2010-09-11 15:55:43]</span></li> <li class="re_txt">您好：我们已经提交给相关人员，商品返货我们会在收到商品以后，从新发货给您的，您最好保持手机畅通，因为快递员如果没有联系到您，也会把商品邮寄回来，给您带来的不便，很抱歉！</li> </ul> </div> <div class="pl_line "> <ul class="zx_zone"> <li>329524078:<strong>2010082856677 (已确认 可以帮我取消吗？········</strong><span>[2010-09-07 22:22:54]</span></li> <li class="re_txt">您好，已经为您取消。</li> </ul> </div> <div class="pl_line gray"> <ul class="zx_zone"> <li>329524078:<strong>请问如何取消已经确定的订单··········</strong><span>[2010-09-07 21:27:02]</span></li> <li class="re_txt">您好，这个需要客服人员帮您取消。</li> </ul> </div> <div class="page_box"> <span><font>«首页</font></span><span><font>­上一页</font></span><span id="page_on"><font>1</font></span><span><a onclick="getcomment(9701, 2, 0,0)" href="#user_comments">2</a></span><span><a onclick="getcomment(9701, 2, 0,0)" href="#user_comments">­下一页</a></span><span><a onclick="getcomment(9701, 2, 0,0)" href="#user_comments">­尾页»</a></span><span><font>1/共2页</font></span> </div>
#HTML
    result["type"]=0
    result["totalcomments"]=nil
    total=@comments.total_entries.to_s
    value_total=PresaleConsulting.count(:conditions=>['product_id=? and hide=0 and value=?',productid,(value-1).abs]).to_s
    if value==0
      result["count"]=total
      result["count2"]=value_total
    else
      result["count"]=value_total
      result["count2"]=total
    end

    result["content"]=html
    result
  end

  def presale_consultings
    if request.post?
      cmt=params[:cmt]

      logger.debug("#"*10)
      logger.debug(cmt)

      parsed_json = ActiveSupport::JSON.decode(cmt)
      logger.debug(parsed_json.class)
      parsed_json.each do |k,v|
        logger.debug(k)
        logger.debug(v)
      end

      email=parsed_json["email"]
      content=parsed_json["content"]
      productid=parsed_json["id"]
      logger.debug("6"*20)
      logger.debug(email)
      logger.debug(content)
      logger.debug(productid)
      product=Product.find_by_id(productid)
      if !content.blank? and product
        pc=PresaleConsulting.new
        if !email.blank? and session.key?("user")
          #u=User.find_by_email(email)
          pc.user_id=session["user"]["id"]
        else
          pc.user_id=-1
        end
        pc.content=content
        pc.product_id=product.id
        pc.ip=request.remote_ip
        #pc.hide=false
        #pc.value=false
        pc.save
        result=gen_comments(productid,0,1)
        render :json=>result
      else
        logger.debug("wrong----------------------------------")
      end
      #redirect_to :action=>

    else

      page=params[:page]
      value=params[:is_essence]
      if page.blank?
        page=1
      end
      if value.blank? or (value!="0" and value!="1")
        value=0
      else
        value=value.to_i
      end

      productid=params[:id]
      result=gen_comments(productid,value,page)
      render :json=>result
    end


  end

  def gen_comments2(productid,value,page)
    @comments=PostsaleComment.paginate :per_page=>4,:page=>page,:conditions=>['product_id=? and hide=0 and value=?',productid,value],:order=>"id desc"
    if @comments.size>0
      html=""
      @comments.each_with_index do |comment,index|
        if comment.user.nil?
          name="匿名"
        else
          name=comment.user.nick
        end
        gray=""
        gray="gray" if (index+1)%2==0
        html+="
<div class=\"pl_line #{gray}\">
  <ul class=\"pl_zone\">
    <li>#{name} 发表于 <span>#{comment.created_at.strftime('%Y-%m-%d %H-%M-%S')}</span></li>
    <li class=\"pl_txt\">#{comment.content}</li>
       </ul>
  <ul class=\"star_zone\">
    <li>创意&nbsp;&nbsp;<span class=\"star s#{comment.creative}\"></span></li>
    <li>功能&nbsp;&nbsp;<span class=\"star s#{comment.feature}\"></span></li>
    <li>品质&nbsp;&nbsp;<span class=\"star s#{comment.quality}\"></span></li>
  </ul>
  <div class=\"clear\"></div>
</div>
"
      end
      current_page=@comments.current_page
      total_pages=@comments.total_pages
      puts html
      logger.debug("$$$$$$$$$$$$$$$$$$444444444")
      logger.debug(MyLib2::gen_page_html2(current_page,total_pages,productid,value))
      html+=MyLib2::gen_page_html2(current_page,total_pages,productid,value)
    else
      html='<div style="text-align: center;"> <br><br>暂无精华评论 </div>'
      if PostsaleComment.count(:conditions=>["product_id=? and hide=0",productid])==0
          html='<div style="text-align: center;"> <br><br>暂无评论，第一个发表评论的人将获得 <span style="color: rgb(191, 2, 0);">50积分</span> </div>'
      end
    end

    result={}
    result["err_msg"]=""
    result["qty"]=1
    result["result"]=""
    total=@comments.total_entries.to_s
    value_total=PostsaleComment.count(:conditions=>['product_id=? and hide=0 and value=?',productid,(value-1).abs]).to_s
    if value==0
      result["count"]=total
      result["count2"]=value_total
    else
      result["count"]=value_total
      result["count2"]=total
    end

    result["content"]=html
    result
  end

  def postsale_comments
    page=params[:page]
    value=params[:is_essence]
    if page.blank? or page=="0"
      page=1
    else
      page=page.to_i
    end
    if value.blank? or (value!="0" and value!="1")
      value=0
    else
      value=value.to_i
    end

    productid=params[:goods_id]
    result=gen_comments2(productid,value,page)
    render :json=>result
  end


end

