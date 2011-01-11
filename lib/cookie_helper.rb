#coding:utf-8
include ActionView::Helpers::TextHelper
include ApplicationHelper
module CookieHelper
  def get_history_product_ids
    str=cookies["history"]
    if str.blank?
      []
    else
      str.strip.split(",")
    end
  end
  def add_history_product(product_id)
    product_ids=get_history_product_ids
    product_ids.unshift product_id.to_s
    product_ids.uniq!
    if product_ids.size>6
      product_ids=product_ids.slice(0,6)
    end
    cookies["history"]={:value=>product_ids.join(","),:expires=>1.year.from_now,:domain=>".geilibuy.com"}
  end
  def clearall
    cookies["shoppingcart"]={:value=>"",:expires=>1.year.from_now,:domain=>".geilibuy.com"}
    cookies["suitecart"]={:value=>"",:expires=>1.year.from_now,:domain=>".geilibuy.com"}
  end
  def has_product?()
    cookie_products=get_products_from_cookie()
    suite_products=get_suite_products_from_cookie()
    if cookie_products.size==0 and suite_products.size==0
      false
    else
      true
    end
  end
  def product_price(product,score)#还要考虑session["user"]
    if score.to_s=="1"
      product.p3
    else
      product.p2
    end
  end
  def product_cost_scores(product,score)#还要考虑session["user"]
    if score.to_s=="1"
      product.s1
    else
      0
    end
  end
  def product_new_scores(product,score)
    product_price(product,score)*10#再去一下零
  end
  def save_products_to_cookie(products)
    r=[]
    products.each do |productid_score,num|
      r<<productid_score+"|"+num.to_s
    end
    cookies["shoppingcart"]={:value=>r.join(","),:expires=>1.year.from_now,:domain=>".geilibuy.com"}
    #cookies["shoppingcart"]=r.join(",")
  end
  def save_suite_products_to_cookie(products)
    r=[]
    products.each do |product_ids_suite_id,num|
      r<<product_ids_suite_id+"|"+num.to_s
    end
    cookies["suitecart"]={:value=>r.join(","),:expires=>1.year.from_now,:domain=>".geilibuy.com"}
  end
  def get_suite_products_from_cookie()#p1,p2,p3|suite_id|num
    str=cookies["suitecart"]
    return {} if str.nil?
    lines=str.strip.split(";")
    products={}
    lines.each do |line|
      product_ids,suite_id,num=line.strip.split("|")
      k="#{product_ids}|#{suite_id}"
      if products.key?(k)#已存在就加数量不再加新的项
        products[k]+=num.to_i if num.to_i>0
      else
        products[k]=num.to_i if num.to_i>0
      end
    end
    products
  end
  def get_products_from_cookie()
    str=cookies["shoppingcart"]
    logger.debug("%%%%%%%%%%%%%%%%%%%%%%%%%")
    logger.debug(str)
    if str.nil?
      return {}
    end
    lines=str.strip.split(",")
    products={}
    lines.each do |line|
      productid,score,num=line.strip.split("|")
      k="#{productid}|#{score}"
      if products.key?(k) 
        products[k]+=num.to_i if num.to_i>0
      else
        products[k]=num.to_i if num.to_i>0
      end
    end
    products
  end
  def get_suiteids()
    cookie_products=get_suite_products_from_cookie()
    if cookie_products.size==0
      []
    else
      product_ids=cookie_products.map{|k,v| k.split("|")[1].strip}.uniq
    end
  end
  def get_productids()
    cookie_products=get_products_from_cookie()
    if cookie_products.size==0
      []
    else
      product_ids=cookie_products.map{|k,v| k.split("|")[0].strip}.uniq
    end
  end
  def get_specific_suite_productids_arr(suite_id)
    cookie_products=get_suite_products_from_cookie()
    r=[]
    cookie_products.each do |product_ids_suite_id,num|
      product_ids,suiteid=product_ids_suite_id.split("|")
      if suite_id.to_s==suiteid.to_s
        num.to_i.times{
        r.concat product_ids.split(",")
        }
      end
    end
    r
  end
  def get_specific_suite_num(suite_id)
    cookie_products=get_suite_products_from_cookie()
    count=0
    cookie_products.each do |product_ids_suite_id,num|
      product_ids,suiteid=product_ids_suite_id.split("|")
      if suite_id.to_s==suiteid.to_s
        count+=num.to_i if num.to_i > 0
      end
    end
    count
  end
  def get_specific_product_num(productid,score)
    cookie_products=get_products_from_cookie()
    k="#{productid}|#{score}"
    if cookie_products.key?(k)
      cookie_products[k]
    else
      0
    end
  end
  def get_productid_num_mapping_dict()
    cookie_products=get_products_from_cookie()
    product_ids=get_productids
    r={}
    product_ids.each do |productid|
      a=get_specific_product_num(productid,0)
      b=get_specific_product_num(productid,1)
      r[productid]=a+b
    end
    r
  end
  def get_suiteid_product_show_mapping_dict()
    cookie_products=get_suite_products_from_cookie()
    suite_ids=get_suiteids
    logger.debug(suite_ids)
    product_shows=ProductShow.find(suite_ids)
    dict={}
    product_shows.each do |product_show|
      dict[product_show.id.to_s]=product_show
    end
    dict
  end
  def get_productid_product_mapping_dict()
    cookie_products=get_products_from_cookie()
    product_ids=get_productids
    logger.debug(product_ids)
    db_products=Product.where("id in (?)",product_ids)
    dict={}
    db_products.each do |product|
      dict[product.id.to_s]=product
    end
    dict
  end
  def get_suite_products_count()
    products=get_suite_products_from_cookie()
    count=0
    products.each do |k,v|
      count+=v
    end
    count
  end
  def get_products_count()
    products=get_products_from_cookie()
    count=0
    products.each do |k,v|
      count+=v
    end
    count+get_suite_products_count()
  end
  def update_suite_product_num_to_cookie3(product_ids,num,suite_id)
    num=num.to_i
    k="#{product_ids}|#{suite_id}"
    products=get_suite_products_from_cookie()
    if num>0
      products[k]=num
      #products
      save_suite_products_to_cookie(products)
    end
  end
  def update_product_num_to_cookie3(productid,num,score)
    num=num.to_i
    k="#{productid}|#{score}"
    products=get_products_from_cookie()
    if num>0
      products[k]=num
      #products
      save_products_to_cookie(products)
    end
  end
  def update_product_num_to_cookie2(productid,num)
    num=num.to_i
    a=get_specific_product_num(productid,0)
    b=get_specific_product_num(productid,1)
    logger.debug("&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&")
    logger.debug(num.class)
    logger.debug(a.class)
    logger.debug(b.class)
    logger.debug(num)
    logger.debug(a)
    logger.debug(b)
    if a+b==num
      return
    end
    if a+b>num
      if a>=num
        add_or_remove_product_from_cookie(productid,0,num-a)
      else
        add_or_remove_product_from_cookie(productid,0,-a)
        add_or_remove_product_from_cookie(productid,1,-(num-a))
      end
    else
      add_or_remove_product_from_cookie(productid,0,num-a-b)
    end
    
  end
  def update_product_num_to_cookie(productid,num)
    #如果有没有积分的先删没有积分的
    num=num.to_i
    dict=get_productid_num_mapping_dict
    if num<=0
      add_or_remove_product_from_cookie(productid,0,-10000)
      add_or_remove_product_from_cookie(productid,1,-10000)
    end
    if dict.key?(productid)
      old_num=get_productid_num_mapping_dict[productid]
      if old_num==num
        return
      elsif old_num<num#增加
        add_or_remove_product_from_cookie(productid,0,num-old_num)
      else#减少
        need_cut_num=old_num-num#>0
        old0=get_specific_product_num(productid,0)
        if old0>=need_cut_num
          add_or_remove_product_from_cookie(productid,0,need_cut_num)
        else
          add_or_remove_product_from_cookie(productid,0,need_cut_num)
          add_or_remove_product_from_cookie(productid,1,old0-need_cut_num)#值是负的，表明是减少
        end
      end
    end
  end
  def add_or_remove_suite_product_from_cookie(product_ids,suite_id,num)#这里的product_ids是1,2,3这样的形式
    num=num.to_i
    k="#{product_ids}|#{suite_id}"
    products=get_suite_products_from_cookie()
    if products.key?(k)
      v=products[k]
      if v+num>0
        products[k]=v+num
      else
        products.delete(k)
      end
    elsif num>0
      products[k]=num
    end
    save_suite_products_to_cookie(products)
  end
  def add_or_remove_product_from_cookie(productid,score,num)
    num=num.to_i
    k="#{productid}|#{score}"
    products=get_products_from_cookie()
    if products.key?(k)
      v=products[k]
      if v+num>0
        products[k]=v+num
      else
        products.delete(k)
      end
    elsif num>0
      products[k]=num
    end
    #products
    save_products_to_cookie(products)
  end
  def myproduct_url(productid)
    "/product/#{productid}"
  end

  def gen_products_html()
    dict=get_productid_product_mapping_dict
    cookie_products=get_products_from_cookie()
    html=""
    price=0
    cookie_products.each do |product_score,num|
      productid,score=product_score.split("|")
      if !dict.key?(productid)
        next
      end
      logger.debug("YYYYYYYYYYYYYYYyyyscore===============")
      logger.debug(score)
      product=dict[productid.to_s]
      price+=product_price(product,score)*num
      #这里如果是积分的话，会显示两个产品，这样还是有问题再说了
html+=%Q{
<dl>
                	<dt><a target="_blank" href="/product/#{productid}"><img width="40" height="40" alt="#{product.name}" src="#{product.i1.url(:mini)}"></a></dt>
                    <dd><a target="_blank" href="/product/#{productid}" title="#{product.name}">#{product.name}</a>  <span>×#{num}</span></dd>
                   <dd>
                                          <span class="price_cart">￥#{score=="1" ? product.p3 : product.p2 }元</span>
                                        <a href="javascript:dropHeadFlowNum_distinguish_score('#{product_score}','您确实要把该商品移出购物车吗？')" class="del_cart">
                    [删除]</a><div class="clear"></div></dd>
                </dl>
}
    end
    suite_products=get_suite_products_from_cookie()
    suite_products.each do |product_ids_suite_id,num|
      product_ids,suite_id=product_ids_suite_id.split("|")
      product_show=ProductShow.find(suite_id)
      price+=product_show.suite_price*num
      html+=%Q{<dl>
                	<dt><img width="40" height="40" alt="#{product_show.suite_name}" src="/themes/default/imgs/global/paked.gif"></dt>
                    <dd>#{truncate product_show.suite_name,:length=>10}<span>×#{num}</span></dd>
                   <dd>
                                           <span class="price_cart">￥#{price(product_show.suite_price)}元</span>
                                        <a href="javascript:dropHeadFlowNum4suite('#{product_ids_suite_id}','您确实要把该商品移出购物车吗？')" class="del_cart">
                    [删除]</a><div class="clear"></div></dd>
                </dl>}
    end
    
    
html+="<p class=\"cart_count\">共<font>#{get_products_count}</font>件商品<br>金额总计：<font>￥#{price}元</font></p>
                <a href=\"/shopping/cart\" class=\"add_cart\"> </a>
"
    html
  end
  
  def get_products_price
    dict=get_productid_product_mapping_dict
    price=0
    productids=get_productids()
    productids.each do |productid|
      price+=get_specific_product_num(productid,1)*product_price(dict[productid],1)
      price+=get_specific_product_num(productid,0)*product_price(dict[productid],0)
    end
    suite_dict=get_suiteid_product_show_mapping_dict
    suite_ids=get_suiteids
    suite_ids.each do |suite_id|
      price+=get_specific_suite_num(suite_id)*suite_dict[suite_id].suite_price
    end
    price
  end
  
  def get_total_cost_scores
    dict=get_productid_product_mapping_dict
    score=0
    productids=get_productids()
    productids.each do |productid|
      score+=get_specific_product_num(productid,1)*product_cost_scores(dict[productid],1)
    end
    score    
  end
  
  def get_total_new_scores(coupon_money=0,cash_money=0)
    #购买产品获得新的积分
    ((get_products_price-coupon_money-cash_money)*10).round
  end
  
  def gen_order_sn
    #2010 1016 121906+四位随机数，共18位,tenpay的transaction_id后10位正好从sn的小时分秒再加4位随机数
    t=Time.now.strftime("%Y%m%d%H%M%S")
    r=rand(9999).to_s
    r=r+"0"*(4-r.size)
    t+r
  end
  
  def calc_delivery_price(delivery_id)
    #根据一些优惠政策生成及产品购买量，用户级别等
    rule=FreeShippingRule.current
    delivery=Delivery.find(delivery_id)
    r=delivery.p1  
    if rule and rule.money<=get_products_price and delivery.name=="普通快递"
      r=0
    end
    r 
  end
  
  def get_total_price(delivery_id,coupon_money=0)
    #根据用户使用了一些积分，等东西，是最终的价格
    calc_delivery_price(delivery_id)+get_products_price-coupon_money
  end
  
  def get_real_money(delivery_id,coupon_money=0,cash_money=0)
    #真正要付的钱，考虑到一些有积分抵金额的情况
    get_total_price(delivery_id,coupon_money)-cash_money
  end
end
