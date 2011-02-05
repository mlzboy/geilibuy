#coding:utf-8
require './lib/my_lib3.rb'
include MyLib3
class TuanController < ApplicationController
  
  def order_send
    @order=Order.where(:tuangou=>true).order("id desc").last
    render "tuan_mail/order_send",:layout=>nil
  end
  
  def order_confirm
    @order=Order.where(:tuangou=>true).order("id desc").last
    render "tuan_mail/order_confirm",:layout=>nil
  end
  
  def everyday#for mail test
    @user=User.last
    @tuan=Tuan.today
    render "tuan_mail/everyday",:layout=>nil
  end
  
  def share
    @tuan=Tuan.today
  end
  #/tuan/unsubscribe?id=1&code=13133dfadfee
  def unsubscribe
    active_code=params[:code]
    #id=params[:id]
    #u=User.find_id_and_active_code(id,active_code)
    #sub=Subscription.find_by_email(u.email)
    sub=Subscription.find_by_email(active_code)
    if sub
      sub.subscribe=false
      sub.save
    end
  end
  def subscribe
    
  end
  def check
    r={"error"=>0,"message"=>""}
    act=request.params[:t_act]
    case act
    when "add_comment"
      cmt=params[:cmt]
      parsed_json = ActiveSupport::JSON.decode(cmt)
      order_id=parsed_json["order_id"]
      tuan_comment=parsed_json["content"]
      product_rank=parsed_json["rank"]
      tuan_order=Order.find_by_id_and_user_id(order_id,current_user.id)
      if tuan_order
        tuan_order.tuan_comment=tuan_comment
        tuan_order.product_rank=product_rank
        tuan_order.save
      end
      current_user.plus_scores(20,"对订单#{tuan_order.tuan.href(tuan_order.sn)}进行评价",true)
      r={"error"=>0,"message"=>"","content"=>{"rank"=>product_rank,"content"=>tuan_comment,"order_id"=>order_id,"groupbuy_id"=>"205","goods_id"=>"10599","comment_id"=>order_id.to_i}}

    when "subscript"
      cmt=params[:cmt]
      parsed_json = ActiveSupport::JSON.decode(cmt)
      email=parsed_json["email"]

      Subscription.create([:email=>email]) unless Subscription.find_by_email(email)
      r["content"]=""
      r["message"]="订阅成功"
    when "buy_check"
      #t_act=buy_check&cmt={"t_city":"i","idinfo":"20101126a","num":"1"}
      @tuan=Tuan.today
      cmt=params[:cmt]
      parsed_json = ActiveSupport::JSON.decode(cmt)
      num=parsed_json["num"]
      num=num.to_i
      buy_num=@tuan.check_buy_num(num)
      logger.debug(buy_num.class)
      logger.debug(num.class)
      logger.debug("^^^********************************")
      if parsed_json.include? "address_id"
        #检测是不是新的地址
      logger.debug("$$$$$$$$$$$$$$$$$$$$$$$$$")
      u=current_user
      if u.addresses.size==0
        logger.debug("HHHHHHHHHHHHHHHHHH")
        consignee=parsed_json["consignee"]#收货人
        #country_id=params[:country]
        province_id=parsed_json["province"]
        city_id=parsed_json["city"]
        district_id=parsed_json["district"]
        address=parsed_json["address"]
        #zipcode=params[:zipcode]
        #tel=params[:tel]
        mobile=parsed_json["mobile"]
        #email=params[:email]
        #n= address_id.blank? ? Address.new : Address.find_by_id(address_id)
        n= Address.new
  
          #n.delivery_time_id=delivery_time_id
          n.consignee=consignee
          n.province_id=province_id
          n.city_id=city_id
          n.district_id=district_id
          n.address=address
          #n.zipcode=zipcode
          #n.tel=tel
          n.mobile=mobile
          n.rate+=1
          n.save
          u.addresses<<n
      end
      end
      
      
      if buy_num!=num
        r["error"]=3
        content={}
        content["freeshippingfee"]=@tuan.free_shipping?(buy_num) ? 1 : 0
        content["shipping_fee"]=@tuan.shipping_fee(buy_num)
        
        if @tuan.everyone_max_num>0
        content["restrict_amount"]=@tuan.everyone_max_num            
        else
        content["restrict_amount"]=1000
        end
        

        
        
        
        content["num"]=buy_num
        content["goods_amount"]=@tuan.pp2.to_f
        content["total_amount"]=@tuan.total_price(buy_num).to_f
        cookies["tuan_num"]={:value=>buy_num,:domain=>".geilibuy.com"}
        r["content"]=content
      elsif has_login? ==false
        r["error"]=2
      else
        r["content"]="165654"
      end
    when "buy_check_num"#=>/tuan/order
      @tuan=Tuan.today
      cmt=params[:cmt]
      parsed_json = ActiveSupport::JSON.decode(cmt)
      #city=parsed_json["t_city"]
      #idinfo=parsed_json["idinfo"]
      num=parsed_json["num"]
      buy_num=@tuan.check_buy_num(num)
      cookies["tuan_num"]={:value=>buy_num,:domain=>".geilibuy.com"}
      content={}
      content["freeshippingfee"]=@tuan.free_shipping?(buy_num) ? 1 : 0
      content["shipping_fee"]=@tuan.shipping_fee(buy_num)
      #content["restrict_amount"]=2#@tuan.everyone_max_num
        if @tuan.everyone_max_num>0
        content["restrict_amount"]=@tuan.everyone_max_num            
        else
        content["restrict_amount"]=1000
        end
      content["num"]=buy_num
      content["goods_amount"]=@tuan.pp2.to_f
      content["total_amount"]=@tuan.total_price(buy_num).to_f
      r["content"]=content
    when "get_countdown"#团购倒计时
      @tuan=Tuan.today
      content={}
      content["buyer_minimum"]=@tuan.min_num
      content["tuangou_user"]=@tuan.current_num
      content["time"]=@tuan.left_time
      content["time_str"]="<b>09</b> 小时&nbsp;&nbsp;<b>32</b> 分钟&nbsp;&nbsp;<b>01</b> 秒"


      if @tuan.current_num<@tuan.min_num
        content["format_buyer_minimum_time"]=""
        left=@tuan.min_num-@tuan.current_num
        content["buyer_needed"]=left

        if @tuan.current_num==0
          html=%Q{
                            <dt><span>来下第一单吧</span><p>数量有限，下单要快哟</p></dt>
                        <dd class="d_chart">
                            <dl id="dealchart">
                                    <dt style="background-position: 0pt 0pt;" id="chart_role"></dt>
                                <dd id="chart_img">
                                    <div style="width: 0pt;" id="d_role"></div><div id="end_role"></div>
                                </dd>
                                <dd id="chart_num"><b style="float: left;">0</b><b style="float: right;">10</b></dd>
                            </dl>
                        </dd>
                        <dd><p>还差<strong>#{left}</strong>人达到最低团购人数</p></dd>
                  }
        else

          html=%Q{
                	<dt><b id="tuangou_user">#{@tuan.current_num}</b> <span>人已购买</span>
                	  <p>数量有限，下单要快哟</p></dt>
                    <dd class="d_chart">
                    	<dl id="dealchart">
                        	<dt style="background-position: #{@tuan.current_num*17}px 0pt;" id="chart_role"></dt>
                            <dd id="chart_img">
                            	<div style="width: #{@tuan.current_num*17}px;" id="d_role"></div><div id="end_role"></div>
                            </dd>
                            <dd id="chart_num"><b style="float: left;">0</b><b style="float: right;">10 </b></dd>
                        </dl>
                    </dd>
                    <dd><p>还差<strong>#{left}</strong>人达到最低团购人数</p></dd>
                }
        end
      else

        content["format_buyer_minimum_time"]=@tuan.min_time.strftime("%H点%M分")
        html=%Q{<dt><b id="tuangou_user">#{@tuan.current_num}</b> <span>人已购买</span><p>数量有限，下单要快哟</p></dt><dd class="d_chart"><div class="dealok">团购已成功可继续购买</div></dd><dd><p id="chengtuan_time"> <br/>到最低团购人数: <strong>#{@tuan.min_num}</strong>人</p></dd>}
      end
      content["htmlstr"]=html
      r["content"]=content
    end

    render :json=>r
  end
  def guide
  end
  def about
    @article=Article.find_by_id(params[:about_id])
  end
  def article
    @article=Article.find_by_id(params[:article_id])
  end
  def index
    yyyymmdd=params[:yyyymmdd]
    logger.debug("!!!!!!!!!!!!!!!#$$$$$$$$$$$$$$$$$$$")
    logger.debug(yyyymmdd)
    unless yyyymmdd
      @tuan=Tuan.today
    else
      @tuan=Tuan.day(yyyymmdd)
    end
  end

  #def register
  #end
  #
  #def login
  #end

  def faq
  end

  def qa
    if request.post?
      question=params[:t_content]
      tuan_id=params[:t_id]
      q=Qa.new
      q.question=question
      q.user_id=current_user.id
      q.tuan_id=tuan_id
      q.ip=request.remote_ip
      q.hide=false

      q.save
      render :json=>{"error"=>"new_id"}
      return
    end
    @tuan=Tuan.today
    page=params[:page]
    page=1 if page.blank?
    sql="select * from qas where hide=0 order by id desc"
    @qas=Qa.paginate_by_sql [sql],:per_page=>3,:page=>page
    #@qas=Qa.where(:hide=>false).order("id desc").all
    @page=MyLib3::gen_page_html3(@qas)
  end

  def deals
    page=params[:page]
    page=1 if page.blank?
    sql="select * from tuans where `on`=1 and start_time < ? order by end_time desc"
    @deals=Tuan.paginate_by_sql [sql,Time.now],:per_page=>10,:page=>page
    @page=MyLib3::gen_page_html3(@deals)
  end

end

