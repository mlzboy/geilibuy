#coding:utf-8
require './lib/cookie_helper.rb'
include CookieHelper
require 'set'
include ActionView::Helpers::NumberHelper
#require "action_view"
class ShoppingController < ApplicationController
  before_filter :login?,:only=>[:checkout,:address,:order_success]
  before_filter :check_score,:only=>[:checkout]
  before_filter :check_shopping_cart,:only=>[:checkout]
  include CookieHelper

  layout 'shopping'
  #$str="p11|1|2,p12|0|1,p11|0|2,p11|1|3"
  #score 1为使用积分，
  def pay_failure
    render :layout=>"front"
  end
  def pay_success
    render 'pay_success',:layout=>"front"
  end
  def update_cart4suite
    product_ids=params[:goods_id].split(",").sort.join(",")
    num=params[:goods_number]
    suite_id=params[:rec_id]
    update_suite_product_num_to_cookie3(product_ids,num,suite_id)
    render :text=>"00"#对应到flow.js中的updatecart方法
  end
  def update_cart
    logger.debug("=================||||||||||||||||||||\=")
    logger.debug(cookies["shoppingcart"])
    productid=params[:goods_id]
    num=params[:goods_number]
    score=params[:rec_id]
    logger.debug("=========score===========")
    logger.debug(score)
    logger.debug("productid")
    logger.debug(productid)
    logger.debug("num")
    logger.debug(num)

    step=params[:step]#=>sum_price,not used
    #用于更新该产品在cookie中的数量
    update_product_num_to_cookie3(productid,num,score)

    render :text=>"00"#对应到flow.js中的updatecart方法
  end
  def check
    r={"error"=>0,"num"=>0,"content"=>' 您的购物车中暂时没有商品。'}

    act=params[:step]
    case act
    when "check_packaging_goods"
      r={"err_msg"=>"0","result"=>"16166","content"=>"该商品存在！"}
      #检查打包销售商品是否是在该组合销售的产品内,是否有货等
      is_err=false
      suite_id=params[:id]
      product_ids=params[:goods_id]
      product_show=ProductShow.find_by_id(suite_id)
      #type=params[:packing_type]
      #if type=="5"
      #  
      #else
        if product_show.nil? or product_ids.blank? or product_ids.split(",").size!=product_show.suite_num
          logger("----------------------ddddddddddddddddddddddeeeeee")
          is_err=true
        else
          product_ids=product_ids.split(",")
          logger.debug(product_ids)
          big_product_ids=product_show.products.collect{|p| p.id.to_s}
          logger.debug(big_product_ids)
          unless product_ids.to_set.subset?(big_product_ids.to_set)
            logger.debug("---------------------------&&&&&&&&&&&&&&&&&&&")
            is_err=true        
          end
        end
        if is_err
          r["content"]="不正确的组合套装!"
          r["err_msg"]="1"
        end
      #end
      logger.debug("GGGGGGDDDDDDDDDDD")
      render :json=>r
    when "change_moneyaccount"#这个可以不要用
      u=current_user
      is_use_cash_money=params[:is_select]
      r={}
      r["error"]=""
      r["content"]=""
      new_info={}
      new_info["huodejifen"]=660
      new_info["huodeyouhuiquan"]="40.00元"
      new_info["moneypay"]="-0.00元"
      new_info["usemoney"]=number_with_precision u.money,:precision=>2
      new_info["yingfujiner"]="66.80元"
      new_info["youhuiquanjianmian"]="-0.00元"
      new_info["yunfei"]="0.00元"
      new_info["zhekouhuodongjianmian"]="0.00元"
      r["new_info"]=new_info
      render :json=>r
    when "change_bonus"
      coupon_id=params[:bonus]
      u=current_user
      coupon=Coupon.find_by_user_id_and_id_and_hide_and_status(u.id,coupon_id,false,"未使用")
      r={}
      r["content"]="kong"
      r["error"]=""
      new_info={}
      new_info["huodejifen"]=660
      new_info["huodeyouhuiquan"]="40.00元"
      new_info["moneypay"]="-0.00元"
      new_info["usemoney"]=number_with_precision u.money,:precision=>2
      new_info["yingfujiner"]="66.80元"
      if coupon and get_products_price>=coupon.min_money and get_products_price>0
        new_info["youhuiquanjianmian"]="-#{number_with_precision coupon.money,:precision=>2}元"
      else
        new_info["youhuiquanjianmian"]="-0.00元"
      end      
      new_info["yunfei"]="0.00元"
      new_info["zhekouhuodongjianmian"]="0.00元"
      r["new_info"]=new_info
      render :json=>r
    when "add_to_cart_arr"
      product_ids=params[:goods_id_arr]
      product_ids=product_ids.strip.split(",").uniq.select{|e| e.strip!=""}
      logger.debug("####################################")
      logger.debug(product_ids)
      product_ids.each do |product_id|
        add_or_remove_product_from_cookie(product_id,0,1)
      end
      render :text=>"true,/shopping/cart"
    when "delet_to_cart_arr"#实际上是删除收藏夹中的产品
      if has_login?
        favorite_ids=params[:goods_id_arr]
        favorite_ids=favorite_ids.strip.split(",").uniq.select{|e| e.strip!=""}
      logger.debug("####################################")
      logger.debug(favorite_ids)
        sql="`id` in (#{favorite_ids.join(',')}) and user_id=#{current_user.id}"
        logger.debug(sql)
        Favorite.destroy_all(sql)
        render :text=>"true,/usercenter/favorites"
      else
        render :text=>"true,/usercenter/login"
      end
    when "get_history"
      product_id=params[:goods_id]
      product_ids=get_history_product_ids
      add_history_product(product_id) unless product_id.blank?
      content=""
      if product_ids.size>0
        products=Product.find(product_ids)
        products.each do |product|
            content+=%Q{

          <a title="#{product.name}" href="/product/#{product.id}" target="_blank">
          <img alt="#{product.name}" src="#{product.i1.url(:thumb)}" height="55" width="55"></a>
        }
        end

        content+=%Q{<div id="clear"></div>}
        r={"err_msg"=>0}
        r["result"]=content
      else
        r={"err_msg"=>"011","result"=>"<div id=\"clear\"><\/div>"}
      end
      render :json=>r
    when "similar_load"
      product_id=params[:goods_id]
      type=params[:type]
      if type=="1"
        page=params[:up]
      elsif type=="2"
        page=params[:next]
      else
        page=params[:page]
      end
      if page.blank?
        page=1
      else
        page=page.to_i
        page=1 if page==0
        page=page.abs
      end
      p=Product.find(product_id)
      whole_categories=p.whole_categories
      categories=[]
      while whole_categories.size>0
        category=whole_categories.pop
        categories<<category
        categories.concat(category.siblings)
        break if categories.size>100
      end
      products=[]
      while categories.size>0
        category=categories.shift
        products.concat(category.online_products(product_id))
        break if products.size>=100
      end
      #没排重和去除产品自身
      #可以考虑将些结果集缓存
      #left=products.size%4
      #if products.size>0 and left!=0
      #  (0...left).each do |i|
      #    products<<products[i]
      #  end
      #end

      total_pages=products.size/4 + (products.size%4 ==0 ? 0 : 1)
      if total_pages!=0
        
        page=page%total_pages
        page=total_pages if page==0
        start=0
        logger.debug("fffffffffffffggggggggggggggggggggggggggggggggggggggggggggg")
        logger.debug(products.size)
        logger.debug(page)
        four_products=products[4*(page-1),4]
        logger.debug("ggggggggggggggggggggggggggggggggggggggggggggg")
        logger.debug(four_products.size)
      else
        page=1
        four_products= Product.paginate_by_sql ["select * from products where `on`=1 and id<>#{product_id} order by rand(#{product_id})"],:per_page=>4,:page=>page
      end

      r["up"]= -page-1
      r["next"]= page+1
      r["codenum"]='11062'
      r["allnum"]='145'
content=%Q{
<ul class="group_img">
}
four_products.each_with_index do |product,index|
    if (index+1)%2==0
      content+='<li class="t_right">'
    else
      content+='<li>'
    end
    content+=%Q{
  <a target="_blank" href="/product/#{product.id}" title="#{product.name}"><img src="#{product.i1.url(:small)}" alt="#{product.name}"></a>
  </li>
  }
end
content+=%Q{
  </ul>
<div class="clear"></div>
<ul class="group_btn">
  <li>
    <input type="hidden" value="#{r['up']}" name="group_up_one" id="group_up_one">
    <a style="cursor: pointer;" id="gu1" class="group_up">上一组</a></li>
  <li class="t_right">
    <input type="hidden" value="#{r['next']}" name="group_next_one" id="group_next_one">
    <a style="cursor: pointer;" id="gd1" class="group_down">下一组</a></li>
</ul>

}
      r["content"]=content

      render :json=>r

    when "casual"
      page=params[:goods_cookie_id]
      page=page.to_i
      product_id=params[:casual_goods_num]
      count=Product.where(:on=>true).count-1#减去自身
      total_pages=count/4 + (count%4 ==0 ? 0 : 1)
      logger.debug("===================================================")
      logger.debug("#{page}")
      logger.debug("total_pages:#{total_pages}")
      type=params[:type]
      if type=="1"
        if page-1==0
          page=total_pages
        else
          page=page-1
        end
      end
      if type=="2"
        page=page+1
        page=page%total_pages
        page=total_pages if page==0
      end

    logger.debug("----------------------------------------------")
    logger.debug(page)
     four_products= Product.paginate_by_sql ["select * from products where `on`=1 and id<>#{product_id} order by rand(#{product_id})"],:per_page=>4,:page=>page
    logger.debug("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@")
    logger.debug(four_products.size)
content=%Q{
      <ul class="group_img">}
four_products.each_with_index do |product,index|
    if (index+1)%2==0
      content+='<li class="t_right">'
    else
      content+='<li>'
    end
    content+=%Q{
  <a target="_blank" href="/product/#{product.id}" title="#{product.name}"><img src="#{product.i1.url(:small)}" alt="#{product.name}"></a>
  </li>
        }
end
content+=%Q{
              </ul>
      <div class="clear"></div>
      <ul class="group_btn">
        <li>
          <input id="group_cookie_tow" name="group_cookie_tow" value="#{page}" type="hidden">
          <a class="group_up" id="gu2" style="cursor: pointer;">上一组</a></li>
        <li class="t_right">
          <input id="casual_goods_num" name="casual_goods_num" value="#{product_id}" type="hidden">
          <a class="group_down" id="gd2" style="cursor: pointer;">下一组</a></li>
      </ul>

}
      r["content"]=content
      r["allnum"]=product_id
      r["cookie_id"]=page
      render :json=>r
    when "get_shipping_money"
      product_id=params[:goods_id]
      city_id=params[:city]
      render :text=>'{"14":20,"6":12,"15":15,"4":20}'
    when "add_to_cart4suite"
      parsed_json = ActiveSupport::JSON.decode(params[:goods])
      product_ids=parsed_json["goods_id"].split(",").sort.join(",")
      suite_id=parsed_json["suite_id"]
      
      add_or_remove_suite_product_from_cookie(product_ids,suite_id,1)
      #组合套装数量为1
      r["num"]=get_products_count()
      r["one_step_buy"]=0
      r["message"]=""
      r["goods_id"]=""
      r["error"]=0
      r["confirm_type"]="4"
      r["content"]="<a href='/shopping/cart' title='查看购物车'>您的购物车中有 0 件商品，总计金额 0.00元。</a>"
      render :json=>r
    when "add_to_cart"

      logger.debug("--------------------------------------------")
      logger.debug("goods")
      logger.debug(params[:goods])
      parsed_json = ActiveSupport::JSON.decode(params[:goods])
      spec=parsed_json["spec"]
      select=parsed_json["select"]
      productid=parsed_json["goods_id"]
      number=parsed_json["number"]
      parent=parsed_json["parent"]
      score=parsed_json["isIntegral"]#0非积分
      if score.blank?
        score=0
      end
      add_or_remove_product_from_cookie(productid,score,number)

      logger.debug("==========================")
      logger.debug(cookies["shoppingcart"])
      r["num"]=get_products_count()
      r["one_step_buy"]=0
      r["message"]=""
      r["goods_id"]=""
      r["error"]=0
      r["confirm_type"]="4"
      r["content"]="<a href='/shopping/cart' title='查看购物车'>您的购物车中有 0 件商品，总计金额 0.00元。</a>"
      render :json=>r


    when "ajaxcartnum"#当购物篮中有数据时返回购物蓝中的数据
      r["num"]=get_products_count()
      if r["num"]==0
        r["content"]=' 您的购物车中暂时没有商品。'
      else
        r["content"]=gen_products_html
      end
      render :json=>r
    when "drop_goods4suite"
      back_url=params[:back_url]
      product_ids,suite_id=params[:id].split("|")
      add_or_remove_suite_product_from_cookie(product_ids,suite_id,-10000)
      if back_url.blank?
        render :text=>""
      else
        render :inline=>"<script>window.location.href='#{back_url}';</script>"
      end
    when "drop_goods_distinguish_score"
      productid,score=params[:id].split("|")
      back_url=params[:back_url]
      add_or_remove_product_from_cookie(productid,score.to_i,-10000)
      if back_url.blank?
        render :text=>""
      else
        render :inline=>"<script>window.location.href='#{back_url}';</script>"
      end
    when "drop_goods"
      productid=params[:id]
      back_url=params[:back_url]
      score=params[:score]
      #删除操作
      #不需要返回结果
      if score.blank?
        add_or_remove_product_from_cookie(productid,0,-10000)
        add_or_remove_product_from_cookie(productid,1,-10000)
      else
        add_or_remove_product_from_cookie(productid,score.to_i,-10000)
      end
      if back_url.blank?
        render :text=>""
      else
        render :inline=>"<script>window.location.href='#{back_url}';</script>"
      end
    when "clear"
      clearall
      redirect_to "/shopping/cart"
    when "select_payment"#not used
      #http://0.0.0.0:3000/shopping/flow.php?step=select_payment&_=1289795590439&payment=5&m=0.5256290589373964
      ##render :text=>'{"error":"","content":"kong","need_insure":0,"payment":1,"pay_code":"cib","new_info":{"usemoney":null,"moneypay":"-0.00元","yingfujiner":"54.00元","youhuiquanjianmian":"-0.00元","zhekouhuodongjianmian":"0.00元","huodejifen":490,"huodeyouhuiquan":"0.00元","yunfei":"5.00元"}}'
      r={"error"=>"","content"=>"kong","need_insure"=>0,"payment"=>1,"pay_code"=>"cib","new_info"=>{"usemoney"=>nil,"moneypay"=>"-0.00元","yingfujiner"=>"54.00元","youhuiquanjianmian"=>"-0.00元","zhekouhuodongjianmian"=>"0.00元","huodejifen"=>490,"huodeyouhuiquan"=>"0.00元","yunfei"=>"5.00元"}}
      render :json=>r
    when "select_shipping"#not used

    end
  end


  def cart
  end

  def region
    level=params[:type]
    target=params[:target]
    parent_id=params[:parent]
    regions=Region.find_all_by_level_and_parent_id(level,parent_id)
    r={"type"=>level.to_i,"target"=>target}
    r["regions"]=regions.map{|region| {"region_id"=>region.id.to_s,"region_name"=>region.name}}
    render :json=>r
  end
  def check_score
    if current_user.score<get_total_cost_scores
      flash[:info]="对不起，您的积分不够，请删除一些积分换购商品再进行结账"
      back_url=params[:back_url]
      if back_url.blank?
        redirect_to "/shopping/cart"
      else
        redirect_to back_url
      end
    end
  end
  def check_shopping_cart
    unless has_product?
        redirect_to "/shopping/cart"
    end
  end
  def checkout
    if request.post?
      use_cash_money=params[:yuebtn]
      coupon_id=params[:bonus]
      delivery_id=params[:shipping]
      payment_id=params[:payment]
      address_id=params[:address_id]
      address=Address.find(address_id)
      delivery=Delivery.find(delivery_id)
      u=current_user

      o=Order.new
      o.delivery_id=delivery.id
      #o.order_status="未确认(未付款)"
      o.user_id=u.id
      #o.payment_name=payment.name
      #o.payment_id=payment.id
      o.consignee=address.consignee
      o.province=address.province.name
      o.city=address.city.name
      o.district=address.district.name
      o.address=address.address
      o.tel=address.tel
      o.mobile=address.mobile
      o.delivery_name=delivery.name
      o.products_num=get_products_count
      o.products_price=get_products_price
      o.ip=request.remote_ip
      o.sn=gen_order_sn
      o.cost_scores=get_total_cost_scores
      logger.debug("===>444444444444444>>>>>real_money")
      logger.debug(o.real_money)
      o.save
      if o.cost_scores>0
        u.minus_scores(o.cost_scores,%Q{积分换购<a href="/usercenter/order_detail/#{o.sn}">#{o.sn}</a>},false,o.id)
        u.score-=o.cost_scores
        if u.score<0
          u.score=0
        end
        u.save
      end
      coupon_money=0
      coupon=Coupon.find_by_user_id_and_id_and_hide_and_status(u.id,coupon_id,false,"未使用")
      if coupon and get_products_price>=coupon.min_money and get_products_price>0
        coupon_money=coupon.money
        o.coupon_id=coupon.id
        o.coupon_money=coupon_money
        coupon.status="已使用"
        coupon.order_id=o.id
        coupon.save
        o.save
      end
      total_price=get_total_price(delivery_id,coupon_money)
      cash_money=0
      if use_cash_money=="on" and u.money>0
        if u.money>0 and total_price>0
          if u.money>total_price
            cash_money=total_price
            total_money=u.money-total_price
          else
            cash_money=u.money
            total_money=0
          end
          CashDetail.create(:user_id=>u.id,:money=>cash_money,:total_money=>total_money,:cost=>true,:order_id=>o.id,:sn=>o.sn)
          u.money=total_money
          u.save
          o.cash_money=cash_money
          o.save
        end
      end
      o.new_scores=get_total_new_scores(coupon_money,cash_money)
      o.real_money=get_real_money(delivery_id,coupon_money,cash_money)#这一次实付的金额      
      o.total_price=total_price#这一单的总金额
      o.delivery_price=calc_delivery_price(delivery_id)#这里几后还要考虑満多少免邮箱什么的
      if o.delivery_price==0
        rule=FreeShippingRule.current
        if rule
          o.memo=rule.name
          o.free_shipping=true
        end
      end
      o.save()     
      order_status_name="未确认"
      order_status_value=1
      order_status_name="等待确认" if o.delivery.name=="货到付款" and o.real_money>0
      if o.real_money==0
        order_status_value=2
        order_status_name="订单确认"
      end
      o.order_statuses<<OrderStatus.create(:name=>order_status_name,:value=>order_status_value,:sn=>o.sn,:ip=>request.remote_ip,:from=>"购物前台",:url=>request.fullpath)
      
      if o.real_money==0
        payment=Payment.find_by_name("现金账户")
      else
        payment=Payment.find_by_id(payment_id)
      end
      logger.debug("============================dd")      
      logger.debug(o.real_money)
      logger.debug(o.real_money)
      logger.debug(o.real_money)
      logger.debug(o.real_money)
      o.payment_name=payment.name
      o.payment_id=payment.id
      o.save 
      #存放到OrderSuite,OrderSuiteProduct上
      suite_ids=get_suiteids
      suiteid_product_show_dict=get_suiteid_product_show_mapping_dict
      suite_ids.each do |suite_id|
        num=get_specific_suite_num(suite_id)
        if num>0
          order_suite=OrderSuite.new
          order_suite.num=num
          order_suite.name=suiteid_product_show_dict[suite_id].suite_name
          order_suite.suite_price=suiteid_product_show_dict[suite_id].suite_price
          order_suite.suite_num=suiteid_product_show_dict[suite_id].suite_num
          order_suite.product_show_id=suiteid_product_show_dict[suite_id].id
          order_suite.order_id=o.id
          order_suite.save
          product_ids=get_specific_suite_productids_arr(suite_id)
          product_ids.each do |product_id|
            OrderSuiteProduct.create(:order_suite_id=>order_suite.id,:product_show_id=>order_suite.product_show_id,:product_id=>product_id)
          end
        end
      end
      #存放到Order,OrderDetail上
      productids=get_productids
      productids.each do |productid|
        num=get_specific_product_num(productid,0)
        if num>0
          p=Product.find(productid)
          op=OrderProduct.new
          op.name=p.name
          op.p1=p.p1
          op.p2=p.p2
          op.p3=p.p3
          op.p4=p.p4
          op.p5=p.p5
          op.score=p.score
          op.s1=p.s1
          op.sub_title=p.sub_title
          op.cost_scores=0
          op.new_scores=product_new_scores(p,0)*num
          op.num=num
          op.product_id=p.id
          op.order_id=o.id
          op.promotion=p.promotion
          op.save
        end
        num=get_specific_product_num(productid,1)
        if num>0
          p=Product.find(productid)
          op=OrderProduct.new
          op.name=p.name
          op.p1=p.p1
          op.p2=p.p2
          op.p3=p.p3
          op.p4=p.p4
          op.p5=p.p5
          op.sub_title=p.sub_title
          op.cost_scores=0
          op.new_scores=product_new_scores(p,1)*num
          op.num=num
          op.product_id=p.id
          op.order_id=o.id
          op.promotion=p.promotion
          op.save
        end
      end
      #同时清空cookie中的shoppingcart,suitecart
      clearall
      if o.real_money==0
        redirect_to "/pay_success"
      else
        redirect_to "/shopping/order_success/#{o.sn}"
      end
      return
    end
    if current_user.addresses.size==0
      render "address"
      return
    end
    unless get_products_count()>0
      redirect_to "/shopping/cart"
      return
    end
    @address=current_user.addresses.first
    @payments=Payment.top
    @deliveries=Delivery.order("position")

  end

  def address_list
    u=User.find_by_email(session["user"]["email"])
    @addresses=u.addresses
  end

  def order_success
    sn=params[:sn]
    logger.debug("===========================fffffffffffffeeeeeeeeeeeeeeeeeeer4rrrr")
    logger.debug(sn)
    @order=Order.find_by_sn(sn)
  end
end

