#coding:utf-8
#include MyLib3
#include MyLib4
require './lib/my_lib1.rb'
require './lib/my_lib2.rb'
require './lib/my_lib3.rb'
require './lib/my_lib4.rb'
include MyLib3
include MyLib4
class UsercenterController < ApplicationController
  layout 'front'
  #before_filter :login?,:only=>[:invites,:index,:address,:order_list,:order_detail,:coupons]
  before_filter :login?,:except=>[:check,:login,:register,:forgot]
  def del_out_of_stock
    out_of_stock_id=params[:out_of_stock_id]
    OutOfStock.destroy(out_of_stock_id)
    redirect_to "/usercenter/out_of_stock" and return
  end
  def new_out_of_stock
    product_id=params[:product_id]
    @product=Product.find_by_id(product_id)
    unless @product
      redirect_to "/usercenter/out_of_stock" and return
    end
    if request.get?
      render :layout=>"usercenter" and return
    else
        
        oos=OutOfStock.new
        oos.user_id=current_user.id
        oos.product_id=@product.id
        oos.mobile=params[:tel]
        oos.message=params[:desc]
        oos.email=params[:email]
        oos.save
        logger.debug("TTTTTTTTTSSSSSSSSSSSSSSFFFFFFFFFFFFF")
        redirect_to "/usercenter/out_of_stock" and return
    end

  end
  def out_of_stock
    @out_of_stocks=current_user.out_of_stocks
    logger.debug("OOOOOOTTTTTTTOFFFFFF")
    logger.debug(@out_of_stocks)
    render :layout=>"usercenter"
  end
  def change_password_by_email
    if request.post?
      pass=params[:new_password]
      u=current_user
      u.password=pass
      u.save
      @error_info="重新设置密码成功！  "
      render "error" and return
    end
  end
  def forgot
    if request.post?
      email=params[:email]
      if email.blank? ==false and User.find_by_email(email)
        CoreMail.find_password(email).deliver
         @error_info="重置密码的邮件已经发到您的邮箱：#{email}  "
      else
         @error_info="不存在该用户  "
      end
      render "error" and return
    end
  end
  
  def invites
    render :layout=>"usercenter"
  end
  def scores
    #@score_details=current_user.score_details
    u=current_user
    page=params[:page]
    page=1 if page.blank?    
    @score_details=ScoreDetail.paginate :conditions=>["user_id=?",u.id],:order=>"id desc",:per_page=>20,:page=>page
    @total_cost=ScoreDetail.where(:user_id=>current_user.id).where("score<0").sum(:score)
    @total_get=ScoreDetail.where(:user_id=>current_user.id).where("score>0").sum(:score)
    @page=MyLib3::gen_page_html3(@score_details)
    render :layout=>"usercenter"
  end
  def coupons
    if request.post?
      @error_info="您输入的红包不存在"
      render "error" and return
    end
    @coupons=Coupon.where(:user_id=>current_user.id).where("end_time>'#{Time.now.strftime("%Y-%m-%d %H:%M:%S")}'").order("id desc")
    render :layout=>"usercenter"
  end
  def vipcard
    render :layout=>"usercenter"
  end
  def exchange
    render :layout=>"usercenter"
  end
  def account
    render :layout=>"usercenter"
  end
  def upload_photo
    @up=UploadPhoto.find_by_id(params[:upload_photo_id])
    render :layout=>"usercenter"
  end
  def specific_upload_photo_list
    @upload_photos=UploadPhoto.find_all_by_user_id_and_product_id(current_user.id,params[:product_id])
    render :layout=>"usercenter"
  end
  def upload_photos
    @products=[]
    ids=[]
    current_user.orders.each do |order|
      if order.current_order_status.value==16
        order.products.each do |product|
          unless ids.include? product.id
            ids << product.id
            @products << product
          end
        end
      end
    end
    render :layout=>"usercenter"
  end
  def presale_consultings
    logger.debug("TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT")
    page=params[:page]
    page=1 if page.blank?
    @presale_consultings=PresaleConsulting.paginate :conditions=>["user_id=?",current_user.id],:order=>"id desc",:per_page=>10,:page=>page
    @page=MyLib3::gen_page_html3(@presale_consultings)
    render :layout=>"usercenter" 
  end
  def postsale_comments
    logger.debug("TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT")
    page=params[:page]
    page=1 if page.blank?
    @postsale_comments=PostsaleComment.paginate :conditions=>["user_id=?",current_user.id],:order=>"id desc",:per_page=>10,:page=>page
    logger.debug(@postsale_comments)
    @page=MyLib3::gen_page_html3(@postsale_comments)
    #logger.debug(MyLib3::test2())
    render :layout=>"usercenter"
  end
  def new_postsale_comment
    product_id=params[:product_id]
    @product=Product.find_by_id(product_id)
    if request.post?
      creative=params[:comment_rank].to_i
      feature=params[:comment_rank_1].to_i
      quality=params[:comment_rank_2].to_i
      pc=PostsaleComment.new
      pc.user_id=current_user.id
      pc.creative=creative
      pc.feature=feature
      pc.quality=quality
      pc.content=params[:content]
      pc.product_id=product_id
      pc.hide=false
      pc.ip=request.remote_ip
      pc.save
      if @product.postsale_comments.size>0
        current_user.plus_scores(20,"发表商品购买评论")
      else
        current_user.plus_scores(50,"发表商品的第一个购买评论")
      end
    end
    render :layout=>"usercenter"
  end
  def upload_new_photo
    product_id=params[:product_id]
    if request.post?
      @up=UploadPhoto.new
      @up.user_id=current_user.id
      @up.product_id=product_id
      @up.i1=params[:attach]
      @up.save
      render "upload_photo_success",:layout=>"usercenter" and return
    end
    @product=Product.find_by_id(product_id)
    render :layout=>"usercenter"
  end
  def mod_password
    if request.post?
      old_password=params[:old_password]
      new_password=params[:new_password]
      u=current_user
      if u.password==old_password
        u.password=new_password
        u.save
        @error_info="修改密码成功！<script>$(function(){
setTimeout(function(){
window.location.href='/usercenter/mod_password'},2000);

});</script>"

      else
        @error_info="密码错误！"
      end
      render "error" and return
    end
    render :layout=>"usercenter"
  end
  def profile
    if request.post?
      u=current_user
      ud=u.user_detail
      ud.introduce=params[:other][:introduce]
      yyyy=params[:birthdayYear]
      mm=params[:birthdayMonth]
      dd=params[:birthdayDay]
      ud.education_id=params[:other][:education].to_i
      ud.job_id=params[:other][:industry].to_i
      ud.gender= params["sex"]=="1" ? true : false
      t=Time.local(yyyy,mm,dd)
      logger.debug("=========================")
      logger.debug(t)
      logger.debug(yyyy)
      logger.debug(mm)
      logger.debug(dd)
      ud.birthday=t
      ud.save
      u.nick=params[:other][:nickname]
      u.save
    end
    @user=current_user
    render :layout=>"usercenter"
  end
  def bought_products
    #sql="select * from ((select * from orders where user_id=? and order_status='已发货') o inner join     order_products op on o.id=op.order_id) op2 order by op2.id desc"
    #@products=OrderProduct.find_by_sql [sql,current_user.id]
    page=params[:page]
    page=1 if page.blank?
    products=[]
    ids=[]
    current_user.orders.each do |order|
      if order.current_order_status.value==16
        #products.concat order.products
        order.products.each do |product|
          unless ids.include? product.id
            products << product
            ids << product.id
          end
        end
      end
    end
    products.reverse!
    logger.debug("=======ZZZZZZZZZZZZZZZZZZZZZZZZZzzzzzzzzz===========")
    logger.debug(products.size)
    logger.debug(products)
    @products,@page = MyLib4::gen_page_html4(products,10,page)
    render :layout=>"usercenter"
  end

  def favorites
    page=params[:page]
    page=1 if page.blank?
    #sql="select p.* from products p inner join (select product_id,`updated_at` from favorites where user_id=?) f on f.product_id=p.id order by f.updated_at desc"
    #@products=Product.paginate_by_sql [sql,current_user.id],:per_page=>10,:page=>page
    @favorites=Favorite.paginate :conditions=>["user_id=?",[current_user.id]],:per_page=>10,:page=>page
    @page=MyLib3::gen_page_html3(@favorites)
    render :layout=>"usercenter"
  end
  

  def order_cancle
    u=current_user
    order_id=params[:id]
    order=Order.find_by_user_id_and_id(u.id,order_id)
    if order
      order.order_statuses << OrderStatus.create(:name=>"取消",:value=>64)
    end
    if order.cash_money>0
      u.money+=order.cash_money
      CashDetail.create(:memo=>%Q{取消订单<a href='/usercenter/order_detail/#{order.sn}'>#{order.sn}</a>返还至现金账户},:user_id=>u.id,:money=>cash_money,:total_money=>u.money,:cost=>false,:order_id=>order.id,:sn=>order.sn)
    end
    if order.cost_scores>0
      u.score+=order.cost_scores
      u.plus_scores(order.cost_scores,%Q{取消订单<a href='/usercenter/order_detail/#{order.sn}'>#{order.sn}</a>返还换购积分},false,order.id)
    end
    u.save
    redirect_to "/usercenter/order_list"
  end
  def order_detail
    sn=params[:sn]
    @order=Order.find_by_sn_and_user_id(sn,current_user.id)
    unless @order
        @error_info="没有找到这张订单"
        render "error"
        return
    end
    render :layout=>'usercenter'
  end
  def order_list
    @orders=current_user.orders.order("id desc")
    render :layout=>'usercenter'
  end
  def address
    u=User.find_by_email(session["user"]["email"])

    if request.post?
      back_url=params[:back_url]
      #consignee=ddd&country=1&province=2&city=52&district=502&address=addressdetail&zipcode=32200&tel=8552151&mobile=143413413411243&best_time=%E5%91%A8%E4%B8%80%E8%87%B3%E5%91%A8%E4%BA%94%E5%9D%87%E5%8F%AF%E9%80%81%E8%B4%A7&act=act_edit_address&email=35386837%40qq.com&address_id=
      consignee=params[:consignee]#收货人
      #country_id=params[:country]
      province_id=params[:province]
      city_id=params[:city]
      district_id=params[:district]
      address=params[:address]
      zipcode=params[:zipcode]
      tel=params[:tel]
      mobile=params[:mobile]
      email=params[:email]
      delivery_time_id=params[:best_time]
      address_id=params[:address_id]
      logger.debug("==========================================")
      logger.debug(address_id)
      #act=params[:act]
      n= address_id.blank? ? Address.new : Address.find_by_id(address_id)
      if n
        n.delivery_time_id=delivery_time_id
        n.consignee=consignee
        n.province_id=province_id
        n.city_id=city_id
        n.district_id=district_id
        n.address=address
        n.zipcode=zipcode
        n.tel=tel
        n.mobile=mobile
        n.rate+=1
        n.save
        u.addresses<<n if address_id.blank?
      end
      unless back_url.blank?
        redirect_to back_url
        return
      end
    end
    @addresses=u.addresses
    render :layout=>"usercenter"
  end

  def index
    logger.debug("=======fffffffffff=====ffffffffffff=========================")
    logger.debug(session["user"])
    #render 'index'
    render 'welcome',:layout=>'usercenter'
  end
  def login
    back_url=params[:back_url]
    if request.get?
      logger.debug("RRRRRRRRRRRRRRRRRRRRRRRRrrrr")
      logger.debug(back_url)
      if session.key?("user")
        redirect_to "/usercenter"
      else
        render 'login'
      end
      #render "login"
    end

    if request.post?
      email=params[:username]
      password=params[:password]
      remember=params[:remember]
      logger.debug("====ffffffffffdddddddd3333333333==================================")
      logger.debug(back_url)
      if remember.blank?
        remember=false
      else
        remember=true
      end
      u=User.find_by_email_and_password(email,password)
      if u
        session["user"]={"email"=>u.email,"nick"=>u.nick,"id"=>u.id,:domain=>".geilibuy.com"}
        cookies["user"]={:value=>u.email,:expires=>1.year.from_now,:domain=>".geilibuy.com"}
        if remember
          cookies["remember"]={:value=>true,:expires=>1.year.from_now,:domain=>".geilibuy.com"}
          cookies["hash"]={:value=>u.active_code,:expires=>1.year.from_now,:domain=>".geilibuy.com"}
        end
        #设置cookie
        if back_url.blank?
          redirect_to "/usercenter"
        else
          redirect_to back_url
        end
      else
        @error_info="用户名密码错误"
        render "error"
      end
    end
  end

  def logout
    session.clear
    #cookies.permanent["remember"]=false
    cookies["remember"]={:value=>false,:expires=>1.year.from_now,:domain=>".geilibuy.com"}
    back_url=params[:back_url]
    if back_url.blank?
      redirect_to "/usercenter/login"
    else
      redirect_to back_url
    end
  end

  def register
    if request.post?

      logger.debug("ddd")
      #设置用户session
      #发送激活邮件，将用户插入数据库，设置active_code
      email=params[:email]
      nick=params[:nick]
      password=params[:password]
      confirm_password=params[:confirm_password]
      back_url=params[:back_url]
      if password!=confirm_password
        @error_info="两次密码不匹配"
        render "error"
      elsif email.index("@").nil? or !User.find_by_email(email).nil?
        @error_info="email错误或已经存在"
        render "error"
      else
        u=User.new
        u.nick=nick
        u.password=password
        u.email=email
        u.active=false
        u.active_code=UUID.new.generate
        u.save
        u.user_detail=UserDetail.create(:user_id=>u.id,:birthday=>Time.now)
        tuan_invite=cookies["tuan_invite"]
        lottery_invite=cookies["lottery_invite"]
        logger.debug("====ZZZZZZZZZZZZZZZZZZZZZZZ=====")
        logger.debug(tuan_invite)
        if tuan_invite.nil? ==false and tuan_invite.blank? ==false and tuan_invite.strip!=""
          old_user=User.find_by_id(tuan_invite.strip)#是这个用户
          if old_user
            logger.debug("找到这个用户了")
#            未购买：您已邀请好友注册，但好友尚未参加过团购，或其参加的团购不返利
#已返利：已经给您返利 5 元
#待返利：好友已团购，将在 24 小时内返利
#审核未通过：因手机号重复等原因被判为无效邀请
            invite=Invite.create(:user_id=>old_user.id,:invited_user_id=>u.id,:ip=>request.remote_ip,:tuangou=>true,:from=>request.referer)
            invite.invite_details<<InviteDetail.create(:name=>"未购买",:value=>1)
          end
        end
        
        if lottery_invite.nil? ==false and lottery_invite.blank? ==false and lottery_invite.strip!=""
          old_user=User.find_by_id(lottery_invite.strip)#是这个用户
          if old_user
            logger.debug("找到这个用户了")
#            未购买：您已邀请好友注册，但好友尚未参加过团购，或其参加的团购不返利
#已返利：已经给您返利 5 元
#待返利：好友已团购，将在 24 小时内返利
#审核未通过：因手机号重复等原因被判为无效邀请
            invite=Invite.create(:user_id=>old_user.id,:invited_user_id=>u.id,:ip=>request.remote_ip,:tuangou=>false,:from=>request.referer)
            invite.invite_details<<InviteDetail.create(:name=>"未激活",:value=>1)
          end
        end        
        
        #ActiveMailer.registration_confirmation(u).deliver
        CoreMail.registration_confirmation(u).deliver
        session[:email]=email
        session[:active]=false
        session[:url]="http://www."+email[email.index("@")+1,email.size]
          #以下两行要extract method
          session["user"]={"email"=>u.email,"nick"=>u.nick,"id"=>u.id}
          cookies["user"]={:value=>u.email,:expires=>1.year.from_now,:domain=>".geilibuy.com"}
          
        if !back_url.blank?
          u.active=true
          u.save

          redirect_to back_url
        else
          redirect_to :action => :active
        end
      end

    end
  end

  def active

  end

  def is_get_lottery(level,product)
    u=current_user
    if u.lucky<product.lucky
      return -1
    else
      u.lucky-=product.lucky
      u.save
      #可以考虑进行变更记录
    end
    lottery=Lottery.first
    level=level.to_i
    return 1 if level>3 or level<1
    num=0
    rate=100000
    if level==1
        num=lottery.first_num
        rate=lottery.first_rate
    elsif level==2
        num=lottery.second_num
        rate=lottery.second_rate
    elsif level==3
        num=lottery.third_num
        rate=lottery.third_rate
    end
    if num==0
      #送优惠券
      Coupon.create(:user_id=>u.id,:name=>"系统发放",:start_time=>Time.now.beginning_of_day,:end_time=>(Time.now+8.days).end_of_day,:status=>"未使用",:kind=>"优惠券",:from=>"系统发放",:min_money=>50,money=>5,:memo=>"抽奖发放")
      return 1
    end
    r=rand(rate)
    logger.debug("=======>>>>>>>")
    logger.debug(r)
    if r==0
      LotteryDetail.create(:user_id=>u.id,:product_id=>product.id,:big=>product.big,:ip=>request.ip)
      if level==1
        lottery.first_num-=1
      elsif level==2
        lottery.second_num-=1
      elsif level==3
        lottery.third_num-=1
      end
      lottery.save
      #写入cookie
      #下次再登录时进行也要写一遍cookie
      return 0
    else
      #送优惠券
      Coupon.create(:user_id=>u.id,:name=>"系统发放",:start_time=>Time.now.beginning_of_day,:end_time=>(Time.now+8.days).end_of_day,:status=>"未使用",:kind=>"优惠券",:from=>"系统发放",:min_money=>50,:money=>5,:memo=>"抽奖发放")
      return 1
    end
  end
  def check
    act=request.params[:act]
    case act
    when "do_exchange"
      r={}
      lucky=params[:num]
      unless has_login?
        r["content"]=""
        r["error"]=-1
        r["message"]="未登录不可使用该功能"
      else
        u=current_user
        content={}
        if lucky.blank? ==false
          lucky=lucky.to_i
          if lucky*3 <= u.score
            r["message"]=""
            r["error"]=0
            #u.score-=lucky*3
            u.lucky+=lucky
            u.save
            u.minus_scores(lucky*3,"兑换幸运点")
            content["integral"]=u.score
            content["num"]=lucky
            content["exchange_num"]=u.score/3
            r["content"]=content
          else
            r["message"]="您的积分不足"
            r["error"]=1
            r["content"]=""
          end
        end

      end
      render :json=>r
    when "find_password"
      user_id=params[:id]
      active_code=params[:hash]
      u=User.find_by_id_and_active_code(user_id,active_code)
      if u
        session["user"]={"email"=>u.email,"nick"=>u.nick,"id"=>u.id,:domain=>".geilibuy.com"}
        render "change_forgot_password"
      else
        @error_info="非法的参数"
        render "error"
      end
    when "act_add_message_nologin"
      Advice.create(:content=>content=params[:msg_content],:ip=>request.remote_ip)
      r={}
      r["error"]=0
      r["message"]="感谢您提交的意见和建议，给力百货的成长离不开您的关注！"
      render :json=>r
    when "do_lottery"
      level,product_id=params[:lottery_id].split("_")
      product=Product.find(product_id)
      error=1
      error=is_get_lottery(level,product) if product
r={}
r["error"]=error#0为中奖，1为不中奖
r["message"]= error==1 ? "没有中奖唉~" : "恭喜，中奖啦！"
content={}
content["brand_id"]=product.brand_id.to_s
content["brand_name"]=product.name
content["cost"]=product.lucky.to_s
content["day_sum"]="20"
content["goods_id"]=product.id.to_s
content["goods_name"]=product.name
content["goods_number"]=error==1 ? "0" :"1"
content["goods_price"]=product.p2.to_s
content["goods_sn"]=product.id.to_s
content["img_require"]=product.i1.url(:medium)
content["info"]=error==1 ? "送你一张优惠券，安慰一下" : "不可思议，竟然被你中奖了"
content["key"]=5
content["lottery_type_id"]="#{level}_#{product.id}"
content["market_price"]=product.p1.to_s
content["original_img"]=product.i1.url
content["promote_price"]=0
content["promote_sign"]=0
content["shop_price"]=product.p2.to_s
content["type"]="1"
content["url"]="/product/#{product.id}"
content["lotterysubmit"]=%q{<a href="javascript:checkuserstatus('0','#{level}_#{product.id}','');">}
r["content"]=content
      render :json=>r
    when "validate_vip"
      render :text=>"7"
    when "money_cardcheck"
      r={"msg"=>-1,"error_re"=>4,"money"=>nil}
      render :json=>r
    when "manyi"
      satisfy=params[:value]
      id=params[:id]
      logger.debug("^^^^^^^^^^^^^^^^^^^^^&&&&&&&&&&&&&&&&^^^^^^^^^^^^^")
      pc=PresaleConsulting.find_by_user_id_and_id(current_user.id,id)
      if pc
        logger.debug("fffff")
        logger.debug(satisfy)
        if satisfy=="1"
          pc.satisfy=true
        else
          pc.satisfy=false
        end
        pc.save
      end
      render :text=>"0"
    when "collect"
      product_id=params[:id]
      back_url=params[:back_url]
      if has_login? and Product.exists?(product_id)
        logger.debug("%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%")
        f=Favorite.find_by_user_id_and_product_id(current_user.id,product_id)
        unless f
          Favorite.create(:user_id=>current_user.id,:product_id=>product_id)
        else
          Favorite.update(f.id,{:rate=>1})
        end
        if back_url.blank?
          render :json=>  {"error"=>0,"message"=>"\u8be5\u73a9\u7269\u5df2\u7ecf\u6210\u529f\u5730\u52a0\u5165\u4e86\u60a8\u7684\u6536\u85cf\u5939\u3002"}
        else
          redirect_to back_url
        end
      else
        if back_url.blank?
          render :json=> {"error"=>1,"message"=>"由于您没有登录,不能使用该功能!"}
        else
          redirect_to back_url
        end
      end
    when "check_email"
        email=params[:email]
        if User.find_by_email(email).nil?
          render :text=>"ok"
        else
          render :text=>"error"
        end
    when "check_captcha"
        captcha=params[:captcha]
        render :text=>1
    when "validate_email"
        u=User.find_by_active_code_and_active(params[:hash],false)
        if u.nil?
          @error_info="验证失败，请确认你的验证链接是否正确"
          if !User.find_by_active_code_and_active(params[:hash],true).nil?
            @error_info="您已经验证过了，不可以重复验证哦"
          end
          render "error"
        else
          u.active=true
          u.lucky=30
          r=Invite.find_by_invited_user_id(u.id)
          if r
            r.invite_details<<InviteDetail.create(:name=>"已激活",:value=>2)
            old_user=User.find(r.user_id)
            old_user.plus_scores(0,"邀请朋友注册激活成功，增加20个幸运点")
            old_user.lucky+=20
            old_user.save
          end
          u.save
          
          #u.plus_scores(30,"邮箱注册激活")
          @user=u
          render "active_success"
        end
    when "check_login_info"
      email=params[:username]
      password=params[:password]
      if User.find_by_email_and_password(email,password)
        render :text=>1
      else
        render :text=>0
      end
    when "check_login"#在产品详细页上
      r={"error"=>0,"content"=>""}
      if session.key?("user")
        r["error"]=1
        r["content"]={"nickname"=>session["user"]["nick"],"have_msg"=>true,"email"=>session["user"]["email"]}
      end
      render :json=>r
    when "ajax_act_add_bonus"
      render :json=>{"error"=>"该优惠券/礼品卡验证码不正确","show"=>""}
    end
    #if act=="check_email"
    #  email=params[:email]
    #  render :text=>"ok"
    #end
    #if act=="check_captcha"
    #  captcha=params[:captcha]
    #  logger.debug("ddddddddddddddddddddddddddddddddddddddddddddddd")
    #  render :text=>1
    #end

  end



end

