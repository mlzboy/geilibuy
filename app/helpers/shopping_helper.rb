#coding:utf-8
require './lib/cookie_helper.rb'
include CookieHelper
module ShoppingHelper
  def show_pop()
    product_price=get_products_price
    rule=FreeShippingRule.current
    html=""
    logger.debug("====rrrrrrrrrrrr==========")
    logger.debug(rule.money)
    if rule
      if rule.money==0
        html=%Q{
                <p><strong>#{rule.name}</strong><br>
       再来几件？&nbsp;&nbsp;<a class="item_opt" href="#trinket_title">看看最受欢迎的小玩意儿&gt;&gt;</a>
      </p>
        }
      elsif product_price < rule.money
        html=%Q{
  <p><strong>全场满#{price2(rule.money)}元免运费</strong><br>
  您差<font>#{price2(rule.money-product_price)}元</font>，再补几件？&nbsp;&nbsp;<a href="#trinket_title" class="item_opt">去挑选热卖商品&gt;&gt;</a>
  </p>}
      else
        html=%Q{
  <p><strong>全场满#{price2(rule.money)}元免运费</strong><br/>
  已经减免货到付款及普通快递运费&nbsp;&nbsp;<a class="item_opt" href="#trinket_title">去看看热卖商品&gt;&gt;</a>
  </p>}
      end
    end
    html
  end

  def gen_shoppingcart
    #从cookie中获取产品以productid|score为键
    cookie_products=get_products_from_cookie()
    productid_product_dict=get_productid_product_mapping_dict
    productid_num_dict=get_productid_num_mapping_dict
    productids=get_productids()
    logger.debug("="*20)
    logger.debug("productids")
    logger.debug(productids)
    #productids=[]
    html=""
    #if productids.size==0
    if !has_product?
    html=<<HTML
<div style=" height:60px; text-align:center; line-height:60px; font-size:16px; font-weight:bold; font-family:microsoft yahei">购物车没有商品</div>
HTML
    return html
    end
    
    html+=<<HTML
<table width="930" border="0" cellpadding="0" cellspacing="0" class="cart_item" id="cart_item">
HTML

    dict=get_productid_product_mapping_dict
    cookie_products.each do |product_score,num|
      this_product_nums=num
      productid,score=product_score.split("|")
      if !dict.key?(productid)
        next
      end
      product=dict[productid.to_s]
      
      price=0
      #logger.debug("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$")
      #logger.debug(product_price(product,0))
      #logger.debug(get_specific_product_num(productid,0))
      #logger.debug(get_specific_product_num(productid,1))
      #logger.debug("$$$$$$$$$$$$$$$$$$$$$$$$$$$$4")
      price=product_price(product,score.to_i)*get_specific_product_num(productid,score.to_i)
      #price+=product_price(product,1)*get_specific_product_num(productid,1)
      scores=product_cost_scores(product,score.to_i)*get_specific_product_num(productid,score.to_i)
      
      if scores>0
        scores=scores.to_s
      else
        scores="<span></span>"
      end


 
      
      
      
      html+=<<HTML
<tr class="goods_tr">
      <td width="78" align="left" valign="middle" class="goods_td"><a href="#{product_url(productid)}" target="_blank"><img src="#{product.i1.url(:thumb)}" width="55" height="55" alt="#{product.name}"/></a></td>
      <td width="265" valign="middle" class="goods_td"><a href="#{product_url(productid)}" target="_blank">#{product.name}</a></td>
      <td width="72" valign="middle" class="goods_td">#{score=="1" ? product.p3 : product.p2  }元</td>
      <td width="84" valign="middle" class="goods_td">
                            <span class="#{'have_trade1' if score=="1"}"></span>
                  <!--<span class="have_vipiece"></span>专享价-->
<!--<span class="have_supirce"></span>特价-->
      </td>
      <td width="130" valign="middle" class="goods_td">
                <span class="num_down" onclick="addorminus('minus','#{productid}','#{score}')"></span>
        <input objNum="#{this_product_nums}" name="" type="text" size="4" maxlength="4" class="num_input" value="#{this_product_nums}" onblur="updatecart(#{productid},#{score},this);this.value=this.value.replace(/[^0-9]/g,'');if(this.value=='')this.value='1'" id='num_input_#{productid}_#{score}' class="goods_num_input"/>
        <span class="num_up" onclick="addorminus('add','#{productid}','#{score}')"></span>
                </td>
      <td width="112" valign="middle" class="goods_td"><font>#{scores}</font></td>
      <td width="118" valign="middle" class="goods_td"><strong>#{price}</strong></td>
      <td valign="middle" class="goods_td"><a class="item_opt" href="javascript:if (confirm('您确实要把该商品移出购物车吗？')) location.href='/shopping/check?step=drop_goods&id=#{productid}&score=#{score}&back_url=/shopping';">删除</a></td><!--use productid replace original id=1335109-->
    </tr>
HTML
    end
    
    suite_products=get_suite_products_from_cookie()
    suite_products.each do |product_ids_suite_id,num|
      product_ids,suite_id=product_ids_suite_id.split("|")
      product_show=ProductShow.find(suite_id)
      product_ids_arr=product_ids.split(",")
      this_product_price=product_show.suite_price*num
      html+=%Q{
<tr class="goods_tr">
      <td align="left" width="78" valign="middle" class="goods_td"><img width="55" height="55" alt="#{product_show.suite_name}" src="/themes/default/imgs/global/paked55.gif"></td>
      <td width="265" valign="middle" class="goods_td"><div style="cursor: default;" class="packed">#{product_show.suite_name}          <div class="packed_list" style="display: none;">
            <div class="packed_in">
                            <table cellspacing="0" cellpadding="0" border="0" width="100%">
                <tr>}
        product_ids_arr.each do |product_id|
          product=Product.find(product_id)
          html+=%Q{
                                <td style="border-bottom: medium none;">
                    <ul class="packed_ul">
                      <li style="height: 60px;"><a target="_blank" href="#{product_url(product.id)}"><img alt="#{product.name}" src="#{product.i1.url(:small)}"></a></li>
                      <li style="height: 18px; display: none;"><font color="#ff0000">1</font>件</li>
                      <li style="height: 20px;"><a target="_blank" href="#{product_url(product.id)}">#{product.name}</a><br cearl="all"></li>
                    </ul>
                  </td>}
        end
        html+=%Q{
                             
                              </tr>
              </table> 
                            <div class="clear"></div>
              <div class="packed_arrow"></div>
            </div>
          </div>
        </div></td>
      <td width="72" valign="middle" class="goods_td">#{price(product_show.suite_price)}元</td>
      <td width="84" valign="middle" class="goods_td">
        <span class="">none</span>
      </td>
      <td width="130" valign="middle" class="goods_td">        <span onclick="addorminus('minus','#{product_ids}','#{suite_id}')" class="num_down"></span>
        <input type="text" class="num_input" id="num_input_#{product_ids.gsub(",","")}_#{suite_id}" onblur="updatecart4suite('#{product_ids}','#{suite_id}',this);this.value=this.value.replace(/[^0-9]/g,'');if(this.value=='')this.value='1'" value="#{num}" maxlength="4" size="4" name="" objnum="#{num}">
        <span onclick="addorminus('add','#{product_ids}','#{suite_id}')" class="num_up"></span>
              </td>
      <td width="112" valign="middle" class="goods_td"><font><span></span></font></td>
      <td width="118" valign="middle" class="goods_td"><strong>#{price(this_product_price)}元</strong></td>
      <td valign="middle" class="goods_td"><a href="javascript:if (confirm('您确实要把该商品移出购物车吗？')) location.href='/shopping/check?step=drop_goods4suite&id=#{product_ids_suite_id}&back_url=/shopping';" class="item_opt">删除</a></td>
    </tr>        
        
      }
      
    end
    
    
    total_price=get_products_price
    total_score=get_total_cost_scores
    html+=<<HTML
      </table>
  <table width="930" border="0" cellpadding="0" cellspacing="0" class="cart_sum">
    <tr>
      <td width="335"><a class="item_opt" href="/">&lt;&lt;继续购物</a>&nbsp;&nbsp;&nbsp;&nbsp;<a class="item_opt" href="/shopping/check?step=clear" onclick="if(confirm('你确定要清空购物车？')){return true;}else{return false;}">清空购物车</a></td>
      <td width="595" height="50" align="right" valign="middle">花费积分：<font>#{total_score}</font>合计：<strong>#{total_price}元</strong></td>
    </tr>
  </table>

HTML
    html
  end
  
  def gen_shoppingcart2#积分和非积分的产品合为一栏
    #从cookie中获取产品以productid|score为键
    cookie_products=get_products_from_cookie()
    productid_product_dict=get_productid_product_mapping_dict
    productid_num_dict=get_productid_num_mapping_dict
    productids=get_productids()
    logger.debug("="*20)
    logger.debug("productids")
    logger.debug(productids)
    #productids=[]
    html=""
    if productids.size==0
    html=<<HTML
<div style=" height:60px; text-align:center; line-height:60px; font-size:16px; font-weight:bold; font-family:microsoft yahei">购物车没有商品</div>
HTML
    return html
    end
    html+=<<HTML
<table width="930" border="0" cellpadding="0" cellspacing="0" class="cart_item" id="cart_item">
HTML

    productids.each do |productid|
      product=productid_product_dict[productid]
      this_product_nums=productid_num_dict[productid]
      price=0
      logger.debug("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$")
      logger.debug(product_price(product,0))
      logger.debug(get_specific_product_num(productid,0))
      logger.debug(get_specific_product_num(productid,1))
      logger.debug("$$$$$$$$$$$$$$$$$$$$$$$$$$$$4")
      price=product_price(product,0)*get_specific_product_num(productid,0)
      price+=product_price(product,1)*get_specific_product_num(productid,1)
      #score=product_score(product,1)*get_specific_product_num(productid,1)
      html+=<<HTML
<tr class="goods_tr">
      <td width="78" align="left" valign="middle" class="goods_td"><a href="#{product_url(productid)}" target="_blank"><img src="#{product.i1.url(:thumb)}" width="55" height="55" alt="#{product.name}"/></a></td>
      <td width="265" valign="middle" class="goods_td"><a href="#{product_url(productid)}" target="_blank">#{product.name}</a></td>
      <td width="72" valign="middle" class="goods_td">#{product.p2}元</td>
      <td width="84" valign="middle" class="goods_td">
                            <span class=""></span>
                  
      </td>
      <td width="130" valign="middle" class="goods_td">
                <span class="num_down" onclick="addorminus('minus','#{productid}','1335109')"></span>
        <input objNum="#{this_product_nums}" name="" type="text" size="4" maxlength="4" class="num_input" value="#{this_product_nums}" onblur="updatecart(#{productid},1335109,this);this.value=this.value.replace(/[^0-9]/g,'');if(this.value=='')this.value='1'" id='num_input_#{productid}_1335109' class="goods_num_input"/>
        <span class="num_up" onclick="addorminus('add','#{productid}','1335109')"></span>
                </td>
      <td width="112" valign="middle" class="goods_td"><font><span></span></font></td>
      <td width="118" valign="middle" class="goods_td"><strong>#{price}元</strong></td>
      <td valign="middle" class="goods_td"><a class="item_opt" href="javascript:if (confirm('您确实要把该商品移出购物车吗？')) location.href='/shopping/check?step=drop_goods&amp;id=#{productid}';">删除</a></td><!--use productid replace original id=1335109-->
    </tr>
HTML
    end
    total_price=get_products_price
    total_score=get_total_cost_scores
    html+=<<HTML
      </table>
  <table width="930" border="0" cellpadding="0" cellspacing="0" class="cart_sum">
    <tr>
      <td width="335"><a class="item_opt" href="http://www.geilibuy.com/">&lt;&lt;继续购物</a>&nbsp;&nbsp;&nbsp;&nbsp;<a class="item_opt" href="/shopping/check?step=clear" onclick="if(confirm('你确定要清空购物车？')){return true;}else{return false;}">清空购物车</a></td>
      <td width="595" height="50" align="right" valign="middle">花费积分：<font>#{total_score}</font>合计：<strong>#{total_price}元</strong></td>
    </tr>
  </table>

HTML
    html
  end


  def gen_shoppingcart_on_checkout_page
    #从cookie中获取产品以productid|score为键
    cookie_products=get_products_from_cookie()
    productid_product_dict=get_productid_product_mapping_dict
    productid_num_dict=get_productid_num_mapping_dict
    productids=get_productids()
    logger.debug("="*20)
    logger.debug("productids")
    logger.debug(productids)
    #productids=[]
    html=""

    html+=<<HTML
<table width="930" border="0" cellpadding="0" cellspacing="0" class="cart_item" id="bought_item">
HTML

    productids.each do |productid|
      product=productid_product_dict[productid]
      this_product_nums=productid_num_dict[productid]
      price=0
      price=product_price(product,0)*get_specific_product_num(productid,0)
      price+=product_price(product,1)*get_specific_product_num(productid,1)
      #score=product_score(product,1)*get_specific_product_num(productid,1)
      html+=<<HTML
            <tr>
      <td width="142" align="center" valign="middle" class="bought_td">
                <a href="#{product_url(productid)}" target="_blank">
          <img src="#{product.i1.url(:thumb)}" width="50" height="50" />
        </a>
                </td>
      <td width="279" valign="middle" class="bought_td">
                <a href="" target="_blank">#{product.name}</a>
                </td>
            <td width="176" valign="middle" class="bought_td">￥#{product.p2}元</td>
            <td width="161" valign="middle" class="bought_td">#{this_product_nums}件</td>
            <td width="172" valign="middle" class="bought_td">￥#{price}元</td>
          </tr>
HTML
    end
    suite_ids=get_suiteids()
    suite_dict=get_suiteid_product_show_mapping_dict
    suite_ids.each do |suite_id|
      price=get_specific_suite_num(suite_id)*suite_dict[suite_id].suite_price
      html+=%Q{
            <tr>
      <td width="142" align="center" valign="middle" class="bought_td">
                
          <img src="/themes/default/imgs/global/paked55.gif" width="50" height="50" />
                </td>
      <td width="279" valign="middle" class="bought_td">
                #{suite_dict[suite_id].suite_name}
                </td>
            <td width="176" valign="middle" class="bought_td">￥#{suite_dict[suite_id].suite_price}元</td>
            <td width="161" valign="middle" class="bought_td">#{get_specific_suite_num(suite_id)}件</td>
            <td width="172" valign="middle" class="bought_td">￥#{price}元</td>
          </tr>}
    end
    

    total_price=get_products_price
    total_score=get_total_cost_scores
    html+=<<HTML
      </table>
      <input type="hidden" name="total_goods_price" id="total_goods_price" value="#{price(total_price)}" />
HTML
    html
  end

  
end
