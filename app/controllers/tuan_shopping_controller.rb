#coding:utf-8
#require "./lib/tuan_lib.rb"
#include TuanLib
class TuanShoppingController < ApplicationController
  before_filter :tuan_login?,:only=>[:checkout,:payment]
  layout 'tuan'
  def order
    @tuan=Tuan.today
  end
  def build_tuan_order(u,payment,tuan,tuan_num,new_scores)
      address=u.addresses.first
      delivery=Delivery.find_by_name("普通快递")
      
      o=Order.new
      o.delivery_id=delivery.id
      o.user_id=u.id
      o.payment_name=payment.name
      o.payment_id=payment.id
      o.consignee=address.consignee
      o.province=address.province.name
      o.city=address.city.name
      o.district=address.district.name
      o.address=address.address
      o.tel=address.tel
      o.mobile=address.mobile
      o.delivery_name=delivery.name
      o.delivery_price=tuan.shipping_fee(tuan_num)
      if o.delivery_price==0
        o.memo="包邮"
        o.free_shipping=true
      end
      o.products_num=tuan_num
      o.products_price=tuan.total_products_price(tuan_num)
      o.total_price=tuan.total_price(tuan_num)
      o.ip=request.remote_ip
      o.sn=gen_order_sn
      o.cost_scores=0
      o.new_scores=new_scores
      o.real_money=tuan.real_money(tuan_num,payment,u.money)
      o.tuan_id=tuan.id
      o.tuangou=true
      o.cash_money=tuan.cash_money(tuan_num,payment,u.money)
      logger.debug("===>444444444444444>>>>>real_money")
      logger.debug(o.real_money)
      o.save
      o.order_statuses<<OrderStatus.create(:name=>"未确认",:value=>1,:tuangou=>true)
      #存放到Order,OrderDetail上
 
      op=OrderProduct.new
      op.name=tuan.title
      op.p1=tuan.pp1
      op.p2=tuan.pp2
      #op.score=p.score
      #op.s1=p.s1
      op.sub_title=tuan.sub_title
      op.cost_scores=0
      op.new_scores=new_scores
      op.num=tuan_num
      op.product_id=tuan.product_id
      op.order_id=o.id
      #op.promotion=p.promotion
      op.tuangou=true
      op.save
      o
  end

  def payment
    if request.get?
      @tuan=Tuan.today
      tuan_num=@tuan.check_buy_num(cookies["tuan_num"])
      @tuan_total_price=@tuan.total_price(tuan_num)
      payment_id=cookies["tuan_payment_id"]
      @payment=Payment.find(payment_id)
      @real_money=@tuan.real_money(tuan_num,@payment,current_user.money)
    end
    if request.post?
      tuan=Tuan.today
      tuan_num=tuan.check_buy_num(cookies["tuan_num"])
      payment_id=cookies["tuan_payment_id"]
      payment=Payment.find(payment_id)
      logger.debug("=====TTTTTTTTTT======")
      logger.debug(payment.name)

      new_scores=tuan.get_new_scores(tuan_num)
      u=current_user

      if u.money>0
        if u.money < tuan.total_price(tuan_num)
          logger.debug("ZZZZZZZZZZZZZZZZZZZZZZ")
          @tuan_order=build_tuan_order(u,payment,tuan,tuan_num,new_scores)
          u.cash_details<< CashDetail.create(:cost=>true,:money=>u.money,:memo=>"现金账户团购T"+@tuan_order.sn,:tuangou=>true,:total_money=>0,:order_id=>@tuan_order.id)
          u.money=0
          u.save
          render 'pay_jump',:layout=>nil
        else
          logger.debug("YYYYYYYYYYYYYY---------------->money>=tuan_total_price")
          if payment.name=="现金账户"
            logger.debug("YYYYYYYYYYYYYY---------------->现金账户")
            @tuan_order=build_tuan_order(u,payment,tuan,tuan_num,0)
            total_money=u.money-tuan.total_price(tuan_num)
            u.cash_details<< CashDetail.create(:cost=>true,:money=>tuan.total_price(tuan_num),:memo=>"现金账户团购"+@tuan_order.sn,:tuangou=>true,:total_money=>total_money,:order_id=>@tuan_order.id)
            u.money=total_money
            u.save
            #支付记录
            ps=PaymentStatus.new
            ps.url=request.request_uri
            ps.ip=request.remote_ip
            ps.from="现金账户"
            ps.order_id=@tuan_order.id
            ps.name="付款成功"
            ps.success=true
            #ps.transaction_id=dict["transaction_id"]
            ps.sn=@tuan_order.sn
            ps.total_fee=tuan.total_price(tuan_num)
            @tuan_order.order_statuses<<OrderStatus.create(:name=>"确认",:value=>2,:tuangou=>true,:from=>"团购前台支付",:url=>request.fullpath)
            redirect_to "/tuan/pay_success/#{@tuan_order.sn}"
          else
            logger.debug("YYYYYYYYYYYYYY---------------->非现金账户")
            @tuan_order=build_tuan_order(u,payment,tuan,tuan_num,new_scores)
            render 'pay_jump',:layout=>nil
          end
        end
      else
        logger.debug("GGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGGG")
        @tuan_order=build_tuan_order(u,payment,tuan,tuan_num,new_scores)
        return render 'pay_jump',:layout=>nil
      end

      #本来要给积分，要30天退换货，这里积分先不加了
      #清空一些cookie
    end
    
  end
  def pay_success
    @tuan_order=Order.find_by_sn(params[:sn])
  end
  def pay_failure
    @tuan_order=Order.find_by_sn(params[:sn])
  end
  def checkout
    @tuan=Tuan.today
    tuan_num=@tuan.check_buy_num(cookies["tuan_num"])
    @tuan_total_price=@tuan.total_price(tuan_num)
    logger.debug(@tuan_total_price)
    logger.debug("checkout000000000000000000000000000000000000000")
    if request.post?

      payment_id=params[:payment]
      payment=Payment.find(payment_id)
      if payment
        cookies["tuan_payment_id"]={:value=>payment_id,:expires=>1.year.from_now,:domain=>".geilibuy.com"}
        redirect_to "/tuan/payment"
      end
    end
    
  end
  


end
