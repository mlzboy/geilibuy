# coding: utf-8
require 'cgi'  
module ApplicationHelper
  def url_encode(str)
    CGI::escape(str)
  end
  def shipping_fee(delivery)
    rule=FreeShippingRule.current
    r=price(delivery.p1)
    if rule and rule.money<=get_products_price and delivery.name=="普通快递"
      r=price(0)
    end
    r
  end
  def tuan_payment_checked(current_payment)
    return ' checked="checked" '   if current_payment.name=="现金账户"
    payment_id=cookies["tuan_payment_id"]
    if payment_id.nil? or payment_id.blank? or payment_id.strip==""
      ""
    else
      if current_payment.id.to_s==payment_id.strip
        ' checked="checked" '
      else
        ""
      end
    end
  end
  def show_tuan_cash_money
    str=cookies["tuan_cash_money"]
    if str.blank?
      ""
    else
      str.strip
    end
  end

  def count_replied_presale_consulting
    PresaleConsulting.where("reply is not null").where(:user_id=>current_user.id).count
  end
  def show_specific_product_count(product_id)
    UploadPhoto.where(:product_id=>product_id).where(:user_id=>current_user.id).count
  end
  def order_status_dict()
    dict={}
    dict[1]="未确认"
    dict[2]="确认"
    dict[4]="正在配货"
    dict[8]="配货完成"
    dict[16]="已发货"
    dict[64]="取消"
    dict[128]="过期"
    dict
  end
  def show_order_status_options(value)
    dict=order_status_dict
    dict.each do |k,v|
      concat(raw %Q{<option value="#{k}" #{"selected" if k==value}>#{v}</option>})
    end
  end
  def show_delivery_company_options(value)
    concat(raw %Q{<option value=""></option>})
    DeliveryCompany.all.each do |delivery_company|
      concat(raw %Q{<option value="#{delivery_company.id}" #{"selected" if delivery_company.id==value}>#{delivery_company.name}</option>})
    end
  end
  def show_order_status(value)
    case value
      when 1
        "下单"
      when 2
        "订单确认"
      when 4
          "开始配货"
      when 8
        "配货完成"
      when 16
          "发货"
      when 64
          "取消"
      when 128
          "过期"
      else
        "未定义状态"
    end
  end
  def show_order_status2(value)
    r=case value
      when 2**0
        "未确认"
      when 2**1
        "已确认"
      when 2**3
        "已发货"
      when 2**6
        "已取消"
      when 2**8
        "已过期"
      else
        ""
    end
    if r!=""
      r="(#{r})"
    end
    r
  end
  def gen_tuan_order_pay_link(tuan_order,ip)
    logger.debug("=================cash_order=========================")
    logger.debug(tuan_order.id)
    logger.debug(tuan_order.payment.name)
    logger.debug(tuan_order.sn)
    logger.debug(tuan_order.real_money)
    logger.debug(ip)
    r=case tuan_order.payment.name.strip
    when "支付宝"
      logger.debug("hhhhhhh")
      AlipayLib::gen_url("团购订单"+tuan_order.sn,tuan_order.sn,tuan_order.real_money,"http://www.geilibuy.com/tuan/","bankPay",tuan_order.tuan.sub_title,"http://www.geilibuy.com/tuan/alipay/respond","http://www.geilibuy.com/tuan/alipay/notify")
    when "财富通"
      TenpayLib::gen_url("团购订单"+tuan_order.sn,tuan_order.sn,tuan_order.real_money,tuan_order.payment.code,ip,"http://www.geilibuy.com/tuan/tenpay/respond")
    else#要排除一些货到付款,现金账户等
      logger.debug("ddddddddddddd")
      TenpayLib::gen_url("团购订单"+tuan_order.sn,tuan_order.sn,tuan_order.real_money,tuan_order.payment.code,ip,"http://www.geilibuy.com/tuan/tenpay/respond")
    end
    logger.debug("rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr")
    logger.debug(r)
    r
  end
  def gen_tuan_cash_pay_link(cash_order,ip)
    logger.debug("=================cash_order=========================")
    logger.debug(cash_order.id)
    logger.debug(cash_order.payment.name)
    logger.debug(cash_order.sn)
    logger.debug(cash_order.money)
    logger.debug(cash_order.name)
    logger.debug(ip)
    r=case cash_order.payment.name.strip
    when "支付宝"
      logger.debug("hhhhhhh")
      logger.debug(cash_order.class)
      logger.debug(cash_order.money)
      AlipayLib::gen_url(cash_order.name,cash_order.sn,cash_order.money,"http://www.geilibuy.com/tuan/account/credit","bankPay",cash_order.description,"http://www.geilibuy.com/tuan/account/alipay/respond","http://www.geilibuy.com/tuan/account/alipay/notify")
    when "财富通"
      TenpayLib::gen_url(cash_order.name,cash_order.sn,cash_order.money,cash_order.payment.code,ip,"http://www.geilibuy.com/tuan/account/tenpay/respond")
    else#要排除一些货到付款,
      logger.debug("ddddddddddddd")
      TenpayLib::gen_url(cash_order.name,cash_order.sn,cash_order.money,cash_order.payment.code,ip,"http://www.geilibuy.com/tuan/account/tenpay/respond")
    end
    logger.debug("rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr")
    logger.debug(r)
    r
  end
  def gen_pay_link(order,ip)
    logger.debug("=================order=========================")
    logger.debug(order.id)
    logger.debug(order.real_money)
    logger.debug(order.payment.name)
    r=case order.payment.name.strip
    when "支付宝"
      logger.debug("hhhhhhh")
      AlipayLib::gen_url("给力百货订单#{order.sn}",order.sn,order.real_money,"http://www.geilibuy.com/usercenter/order_detail/"+order.sn,"bankPay","","http://www.geilibuy.com/alipay/respond","http://www.geilibuy.com/alipay/notify")
    when "财富通"
      TenpayLib::gen_url("给力百货订单#{order.sn}",order.sn,order.real_money,order.payment.code,ip,"http://www.geilibuy.com/tenpay/respond")
    else
      logger.debug("ddddddddddddd")
      TenpayLib::gen_url("#{order.sn}",order.sn,order.real_money,order.payment.code,ip,"http://www.geilibuy.com/tenpay/respond")
    end
    logger.debug("rrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr")
    logger.debug(r)
    r
  end
  #包括它自身的id
  def has_address?
    if has_login?
      current_user.addresses.size > 0
    else
      false
    end
  end
  def current_user
      User.find_by_email(session["user"]["email"])
  end

  def show_tuan_status(tuan)
    if tuan.selling?#抢购
      ""
    elsif tuan.sellout?#卖光
      " d_btn1"
    else#结束
      " d_btn2"
    end
  end
  def mytuan_url(tuan)
    "/tuan/deals/#{show_yyyymmdd(tuan.start_time)}"
  end

  def show_chinese_yyyymmddmmhh(time)
    time.strftime("%Y年%m月%d日%H时%M分")
  end
  def show_chinese_yyyymmdd(time)
    time.strftime("%Y年%m月%d日")
  end
  def show_chinese_yyyymmdd2(time)
    t=time.strftime("%Y年%m月%d日 ")
    num=time.strftime("%w")
#%w: 表示星期几的数字. 星期天是0(0-6)
    dict={0=>"星期日",
1=>"星期一",
2=>"星期二",
3=>"星期三",
4=>"星期四",
5=>"星期五",
6=>"星期六",
}
    t+dict[num.to_i]
  end
  def show_yyyymmdd(time)
    time.strftime("%Y%m%d")
  end
  def show_human_time(time)
    diff=Time.now-time
    if diff<60
      n=number_with_precision(diff,:precision=>0)
      "#{diff}秒以前"
    elsif diff<3600
      n=number_with_precision(diff/60,:precision=>0)
      "#{n}分钟前"
    elsif diff<3600*24
      n=number_with_precision(diff/60/60,:precision=>0)
      "约#{n}小时前"
    elsif diff<3600*24*7
      n=number_with_precision(diff/60/60/24,:precision=>0)
      "约#{n}天前"
    else
      Time.now.strftime("%Y-%m-%d %H:%M:%S")
    end
  end
  def show_promotion_num(product)
    r=(product.p1-product.p2)/product.p1
    logger.debug(r)
    logger.debug("======GGGGGGGGGGGGGGG=========")
    number_to_percentage(r*100,:precision=>0)
  end
  def show_tuan_discount(tuan)
    r=tuan.pp2/tuan.pp1
    #r=r*10
    rr=number_with_precision(r*10,:precision=>1)
    if rr[-2,2]=".0"
      rr[0,rr.size-2]
    end
  end
  def show_tuan_login_back_url
    if params[:back_url].blank?
      "?back_url=/tuan/"
    else
      "?back_url=#{params[:back_url]}"
    end
  end
  def show_tuan_register_back_url
    if params[:back_url].blank?
      "?back_url=/tuan/account/regok"
    else
      "?back_url=#{params[:back_url]}"
    end
  end
  def all_products_under_category(category)
    products=Product.find_by_sql("select * from products p inner join (SELECT distinct product_id FROM categories_products cp where category_id in (38)) cp2 on p.id=cp2.product_id order by id desc")
  end
  def all_brands_under_category(category)
    brands=Product.find_by_sql("select distinct id,name from brands b inner join (select brand_id from products p inner join (SELECT distinct product_id FROM categories_products cp where category_id in (38)) cp2 on p.id=cp2.product_id) p2 on p2.brand_id=b.id")
  end
  def all_products_under_category_and_brands()
    products=Product.find_by_sql("select * from (select * from products p inner join (SELECT distinct product_id FROM categories_products cp where category_id in (38)) cp2 on p.id=cp2.product_id) p2 where p2.brand_id=20 order by id desc")
  end
  def all_products_under_category_and_brands_and_price()
    products=Product.find_by_sql("select * from (select * from products p inner join (SELECT distinct product_id FROM categories_products cp where category_id in (38)) cp2 on p.id=cp2.product_id) p2 where p2.brand_id=20 and p2 between 1 and 5 order by id desc")
  end
  def has_login?
    if session.key?("user")
      true
    else
      #进行cookie检查
      false

    end
  end
  def show_delivery_time_options(selected=0)
    DeliveryTime.all(:order=>"position").each do |delivery|
      concat(raw %Q{<option value="#{delivery.id}" #{"selected" if selected==delivery.id}>#{delivery.name}</option>})
    end
  end
  def show_district_options(selected)
    concat(raw %Q{<option value="0" #{"selected" if selected==0}>请选择县</option>})
    Region.find_all_by_parent_id(Region.find_by_id(selected).parent_id).each do |district|
      concat(raw %Q{<option value="#{district.id}" #{"selected" if selected==district.id}>#{district.name}</option>})
    end
  end
  def show_city_options(selected)
    concat(raw %Q{<option value="0" #{"selected" if selected==0}>请选择市</option>})
    Region.find_all_by_parent_id(Region.find_by_id(selected).parent_id).each do |city|
      concat(raw %Q{<option value="#{city.id}" #{"selected" if selected==city.id}>#{city.name}</option>})
    end
  end
  def show_province_options(selected=0)
    concat(raw %Q{<option value="0" #{"selected" if selected==0}>请选择省</option>})
    Region.provinces.each do |province|
      concat(raw %Q{<option value="#{province.id}" #{"selected" if selected==province.id}>#{province.name}</option>})
    end
  end
  def show_nick
    if session.key?("user")
      n=session["user"]["nick"]
      if !n.blank?
        n
      else
        show_email
      end
    else
      ""
    end
  end
  def show_email
    if session.key?("user")
      session["user"]["email"]
    else
      ""
    end
  end
  def show_image(model,field_name)
    if !eval("model.#{field_name}.file?")
      return ""
    end
    str="<p>
  <b>i1:</b>"
    code=<<"CODE"
    str<<(image_tag model.#{field_name}.url)
    arr=model.#{field_name}.styles.keys.reject{|k| k==:process}
    for k in arr
      w=model.avatar_geometry(field_name,k).width.to_i
      h=model.avatar_geometry(field_name,k).height.to_i
      str<<("<b>"+w.to_s+"x"+h.to_s+"</b>")
      str<<(image_tag model.#{field_name}.url(k))
    end
    str<<(link_to "crop",'/admin/crops?model_name=#{model.class.name}&field_name=#{field_name}&id=#{model.id}')
CODE
    #logger.debug("=========================")
    #logger.debug(code)
    eval(code)
    logger.debug(str)
    str<<"</p>"
  end

  def header()
    @cateogries=Category.find(:all,:conditions=>"special=0 and parent_id is null",:order=>"position")
  end
  def get_brands()
    Brand.where(:hide=>false).all
  end
  def brand_url(brand_id)
    brand_id.to_s
  end
  def ad_materials(slot_name,location,category_name)
    category_id=-1
    if !category_name.blank?
      category_id=Category.find_by_name(category_name).id
    end
    slot_id=Slot.find_by_name_and_location_and_category_id(slot_name,location,category_id).id
    logger.debug(slot_id)
    logger.debug("===========")
    materials=Material.find_by_sql(["select * from (select * from materials_slots where slot_id=?) ms inner join materials m on ms.material_id=m.id order by ms.position",slot_id])
  end
  def cs_products(comment_show_name,location,category_name)
    category_id=-1
    if !category_name.blank?
      category_id=Category.find_by_name(category_name).id
    end
    comment_show_id=CommentShow.find_by_name_and_location_and_category_id(comment_show_name,location,category_id).id
    logger.debug(comment_show_id)
    logger.debug("===========")
    comments=PostsaleComment.find_by_sql(["select * from (select * from comment_shows_postsale_comments where comment_show_id=?) cspc inner join postsale_comments pc on cspc.postsale_comment_id=pc.id order by cspc.position",comment_show_id])
  end
  def ps_products(product_show_name,location,category_name)
    category_id=-1
    if !category_name.blank?
      category_id=Category.find_by_name(category_name).id
    end
    product_show_id=ProductShow.find_by_name_and_location_and_category_id(product_show_name,location,category_id).id
    logger.debug(product_show_id)
    logger.debug("===========")
    products=Product.find_by_sql(["select * from (select * from product_shows_products where product_show_id=?) psp inner join products p on psp.product_id=p.id order by psp.position",product_show_id])
  end
  #此方法自动生成，所以使用
  def product_url(product_id)
    "/product/#{product_id}"
  end
  def myproduct_url(product_id)
    "/product/#{product_id}"
  end

  def top_cateogries_with_home(slot)
    category_id=slot.category_id
    concat(raw "<select name='category_id' id='category_id'>")
    container=[]
    for category in Category.top
      container.push([category.name,category.id])
    end
    if slot.new_record? or slot.category_id==-1
      concat(raw "<option value='-1' selected>home</option>")
      concat(raw options_for_select(container, selected = nil))
    else
      concat(raw "<option value='-1'>home</option>")
      concat(raw options_for_select(container, selected = [Category.find_by_id(category_id).name,category_id]))
    end
    concat(raw "</select>")
  end

  def size_helper()
    #sizes=Material.find(:all,:select=>"distinct size").collect{|k| k.size}
    sizes=Material.find_by_sql("select * from (select size from materials m union select size from slots s) t where t.size<>''").collect{|k| k.size}
    concat(raw "<select name='size_helper' id='size_helper'>")
    concat(raw "<option value=''></option>")
    concat(raw options_for_select(sizes))
    concat(raw "</select>")
  end

  def location_helper()
    concat(raw '<select id="location_helper">')
    concat(raw '<option></option>')
    concat(raw '<option>首页</option>')
    concat(raw '<option>顶级分类</option>')
    concat(raw '</select>')
  end

  def kind_helper()
    concat(raw '<select id="kind_helper">')
    concat(raw '<option></option>')
    concat(raw '<option>图片</option>')
    concat(raw '<option>文字链</option>')
    concat(raw '</select>')
  end

  def slot_name_helper()
    names=Slot.find_by_sql("select distinct name from slots").collect{|k| k.name}
    concat(raw "<select name='name_helper' id='name_helper'>")
    concat(raw options_for_select(names))
    concat(raw "</select>")
  end
  def product_show_name_helper()
    names=Slot.find_by_sql("select distinct name from product_shows").collect{|k| k.name}
    concat(raw "<select name='product_show_name_helper' id='product_show_name_helper'>")
    concat(raw '<option selected></option>')
    concat(raw options_for_select(names))
    concat(raw "</select>")
  end
  def product_show_kind_helper()
    names=ProductShow.find_by_sql("select distinct kind from product_shows").collect{|k| k.kind}
    concat(raw "<select name='product_show_kind_helper' id='product_show_kind_helper'>")
    concat(raw '<option selected></option>')
    concat(raw options_for_select(names))
    concat(raw "</select>")
  end
  def show_category_name(category_id)
    c=Category.find_by_id(category_id)
    if c.nil?
      "首页"
    else
      c.name
    end
  end
  def myarticle_list_url(article_category_id)
    "/article_list/#{article_category_id}"
  end
  def myarticle_tuan_url(article_id)
    "/tuan/about/#{article_id}"
  end
  def myarticle_url(article_id)
    "/article/#{article_id}"
  end
  def brand_url(brand_id)
    "/brands/#{brand_id}"
  end
  def category_url(category_id)
    "/category/#{category_id}"
  end
  def mycategory_url(category_id)
    "/category/#{category_id}"
  end
  def mygift_url(gift_id)
    "/gift/#{gift_id}"
  end
  def price(p1)
    number_with_precision p1,:precision=>2
  end
  def price2(p1)
    number_with_precision p1,:precision=>0
  end
end

