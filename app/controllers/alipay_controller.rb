#coding:utf-8
class AlipayController < ApplicationController
  protect_from_forgery :except => [:notify_url_process,:tuan_notify_url_process,:tuan_cash_notify_url_process]
#http://www.15-1688.com:3000/alipay/respond?trade_status=TRADE_FINISHED&is_success=T&out_trade_no=201012091228153828&trade_no=1111&total_fee=2020&fee_type=1&attach=&sign=1f2e78e07186879d1c91264185452c3f
  def return_url_process
    dict={}
    params.each do |k,v|
      if k!="sign" and k!="sign_type" and k!="action" and k!="controller" and v!=""
        dict[k]=v
      end
    end
    logger.debug(dict)
    gen_sign=AlipayLib::gen_sign(dict,"dl5iyfy9ksdiyqvo79sq4m4ztgcv1722")
    logger.debug("-----------------------------------------------------------------")
    logger.debug("gen_sign")
    logger.debug(gen_sign)
    pay_success=false
    ps=PaymentStatus.new
    ps.url=request.request_uri
    ps.ip=request.remote_ip
    ps.from="支付宝"
    ps.memo="来自支付宝-同步接口通知"
    sn=params[:out_trade_no]
    ps.sn=sn
    if gen_sign==params[:sign]
      order=Order.find_by_sn(sn)
      ps.order_id=order.id
      times=OrderStatus.where(:order_id=>order.id).where(:from=>"支付宝").count
      ps.memo+="。第#{times+1}次通知"
      ps.transaction_id=params[:trade_no]
      ps.total_fee=params[:total_fee]
      if params[:trade_status]=="TRADE_FINISHED" or params[:trade_status]="TRADE_SUCCESS"
        ps.name="付款成功"
        ps.success=true
        order.order_statuses<<OrderStatus.create(:name=>"订单确认",:value=>2,:from=>"支付宝",:url=>request.fullpath,:ip=>request.remote_ip,:memo=>ps.memo,:sn=>sn)     
        pay_success=true
      else
        ps.name="付款未成功"
      end
    else
      ps.name="签名不对"
      ps.memo+=",非法"
      logger.debug("签名不对")
    end
    ps.save
    if pay_success
      redirect_to "/pay_success"
    else
      redirect_to "/pay_failure"
    end
  end
#http://www.15-1688.com:3000/alipay/notify?trade_status=TRADE_FINISHED&is_success=T&out_trade_no=201012091228153828&trade_no=1111&total_fee=2020&fee_type=1&attach=&sign=3cc3b8c94797a5f4d060a1fdb95a0301
  def notify_url_process
    dict={}
    params.each do |k,v|
      if k!="sign" and k!="sign_type" and k!="action" and k!="controller" and v!=""
        dict[k]=v
      end
    end
    logger.debug(dict)
    gen_sign=AlipayLib::gen_sign(dict,"dl5iyfy9ksdiyqvo79sq4m4ztgcv1722")
    logger.debug("-----------------------------------------------------------------")
    logger.debug("gen_sign")
    logger.debug(gen_sign)
    pay_success=false
    ps=PaymentStatus.new
    ps.url=request.request_uri
    ps.ip=request.remote_ip
    ps.from="支付宝"
    ps.memo="来自支付宝-异步接口通知"
    sn=params[:out_trade_no]
    ps.sn=sn
    if gen_sign==params[:sign]
      order=Order.find_by_sn(sn)
      times=OrderStatus.where(:order_id=>order.id).where(:from=>"支付宝").count
      ps.memo+=",第#{times+1}次通知"
      ps.order_id=order.id
      ps.transaction_id=params[:trade_no]
      ps.total_fee=params[:total_fee]
      if params[:trade_status]=="TRADE_FINISHED" or params[:trade_status]="TRADE_SUCCESS"
        ps.name="付款成功"
        ps.success=true
        order.order_statuses<<OrderStatus.create(:name=>"订单确认",:value=>2,:from=>"支付宝",:url=>request.fullpath,:ip=>request.remote_ip,:memo=>ps.memo,:sn=>sn)
        pay_success=true
      else
        ps.name="付款未成功"
      end
    else
      ps.name="签名不对"
      ps.memo+=",非法"
      logger.debug("签名不对")
    end
    ps.save
    if pay_success
      render :text=>"success"
    else
      render :text=>"error"
    end
  end
  
  
  
 #http://www.15-1688.com:3000/tuan/alipay/respond?trade_status=TRADE_FINISHED&is_success=T&out_trade_no=201012091154465983&trade_no=1111&total_fee=2020&fee_type=1&attach=&sign=4b1e49b81fb9863afa847e7473595183
  def tuan_return_url_process
    dict={}
    params.each do |k,v|
      if k!="sign" and k!="sign_type" and k!="action" and k!="controller" and v!=""
        dict[k]=v
      end
    end
    logger.debug(dict)
    gen_sign=AlipayLib::gen_sign(dict,"dl5iyfy9ksdiyqvo79sq4m4ztgcv1722")
    logger.debug("-----------------------------------------------------------------")
    logger.debug("gen_sign")
    logger.debug(gen_sign)
    pay_success=false
    ps=PaymentStatus.new
    ps.url=request.request_uri
    ps.ip=request.remote_ip
    ps.from="支付宝"
    ps.tuangou=true
    ps.memo="来自支付宝-团购-同步接口通知"
    sn=params[:out_trade_no]
    ps.sn=sn
    if gen_sign==params[:sign]
      sn=params[:out_trade_no]
      order=Order.find_by_sn(sn)
      ps.sn=sn
      ps.order_id=order.id
      times=OrderStatus.where(:order_id=>order.id).where(:from=>"支付宝").count
      ps.memo+="。当前为该订单的第#{times+1}次通知"
      ps.transaction_id=params[:trade_no]
      ps.total_fee=params[:total_fee]
      if params[:trade_status]=="TRADE_FINISHED" or params[:trade_status]="TRADE_SUCCESS"
        ps.name="付款成功"
        ps.success=true
        order.order_statuses<<OrderStatus.create(:name=>"订单确认",:value=>2,:tuangou=>true,:from=>"支付宝",:url=>request.fullpath,:ip=>request.remote_ip,:memo=>ps.memo,:sn=>sn)       
        tuan=order.tuan
        tuan.current_num+=1
        tuan.save
        pay_success=true
      else
        ps.name="付款未成功"
      end
    else
      ps.name="签名不对"
      ps.memo+="，非法"
      logger.debug("签名不对")
    end
    ps.save
    if pay_success
      redirect_to "/tuan/pay_success/"+params[:out_trade_no]
    else
      redirect_to "/tuan/pay_failure/"+params[:out_trade_no]
    end
    
  end
  

#http://www.15-1688.com:3000/tuan/alipay/notify?trade_status=TRADE_FINISHED&is_success=T&out_trade_no=201012091154465983&trade_no=1111&total_fee=2020&fee_type=1&attach=&sign=3cc3b8c94797a5f4d060a1fdb95a0301
  def tuan_notify_url_process
    dict={}
    params.each do |k,v|
      if k!="sign" and k!="sign_type" and k!="action" and k!="controller" and v!=""
        dict[k]=v
      end
    end
    logger.debug(dict)
    gen_sign=AlipayLib::gen_sign(dict,"dl5iyfy9ksdiyqvo79sq4m4ztgcv1722")
    logger.debug("-----------------------------------------------------------------")
    logger.debug("gen_sign")
    logger.debug(gen_sign)
    pay_success=false
    ps=PaymentStatus.new
    ps.url=request.request_uri
    ps.ip=request.remote_ip
    ps.from="支付宝"
    ps.tuangou=true
    ps.memo="来自支付宝-团购-异步通知异步接口"
    sn=params[:out_trade_no]
    ps.sn=sn
    if gen_sign==params[:sign]
      order=Order.find_by_sn(sn)
      ps.order_id=order.id
      ps.total_fee=params[:total_fee]
      ps.transaction_id=params[:trade_no]
      times=OrderStatus.where(:order_id=>order.id).where(:from=>"支付宝").count
      ps.memo+="。当前为该订单的第#{times+1}次通知"
      if params[:trade_status]=="TRADE_FINISHED" or params[:trade_status]="TRADE_SUCCESS"
        ps.name="付款成功"
        ps.success=true
        order.order_statuses<<OrderStatus.create(:name=>"订单确认",:value=>2,:tuangou=>true,:from=>"支付宝",:url=>request.fullpath,:ip=>request.remote_ip,:memo=>ps.memo,:sn=>sn)       
        tuan=order.tuan
        tuan.current_num+=1
        tuan.save
        pay_success=true
      else
        ps.name="付款未成功"
      end
    else
      ps.memo+="，非法"
      ps.name="签名不对"
      logger.debug("签名不对")
    end
    ps.save
    if pay_success
      render :text=>"success"
    else
      render :text=>"error"
    end
  end
  












#http://www.15-1688.com:3000/tuan/account/alipay/respond?trade_status=TRADE_FINISHED&is_success=T&out_trade_no=201012091136235045&trade_no=1111&total_fee=2020&fee_type=1&attach=&sign=77277fc5793cc8d0ca5867cbe47ca0b5
  def tuan_cash_return_url_process
    dict={}
    params.each do |k,v|
      if k!="sign" and k!="sign_type" and k!="action" and k!="controller" and v!=""
        dict[k]=v
      end
    end
    logger.debug(dict)
    gen_sign=AlipayLib::gen_sign(dict,"dl5iyfy9ksdiyqvo79sq4m4ztgcv1722")
    logger.debug("-----------------------------------------------------------------")
    logger.debug("gen_sign")
    logger.debug(gen_sign)
    pay_success=false
    ps=PaymentStatus.new
    ps.url=request.request_uri
    ps.ip=request.remote_ip
    ps.from="支付宝"
    ps.tuangou=true
    ps.memo="来自支付宝-团购-现金账户-同步通知接口"
    sn=params[:out_trade_no]
    ps.sn=sn
    if gen_sign==params[:sign]
      co=CashOrder.find_by_sn(sn)
      ps.cash_order_id=co.id
      times=OrderStatus.where(:cash_order_id=>co.id).where(:from=>"支付宝").count
      ps.memo+="。当前为该订单的第#{times+1}次通知"
      ps.transaction_id=params[:trade_no]
      ps.total_fee=params[:total_fee]
      if params[:trade_status]=="TRADE_FINISHED" or params[:trade_status]="TRADE_SUCCESS"
        ps.name="付款成功"
        ps.success=true
        co.cash_order_statuses<<OrderStatus.create(:name=>"订单确认",:value=>2,:tuangou=>true,:from=>"支付宝",:url=>request.fullpath,:ip=>request.remote_ip,:sn=>sn,:memo=>ps.memo)       
        c=OrderStatus.where(:cash_order_id=>co.id).where("`value`>1").count
        if c==1#每次还是记录接收到的请求，但是不重复加钱
          u=co.user
          u.money+=co.money
          u.save
          u.cash_details<< CashDetail.create(:cost=>false,:money=>co.money,:memo=>"充值",:tuangou=>true,:total_money=>u.money,:cash_order_id=>co.id,:sn=>sn)
          u.plus_scores((co.money*10).round,"现金充值奖励积分",true)#先乘10再round
          logger.debug("加钱")
          ps.memo+=",加钱"
        else
          ps.memo+=",不加钱"
          logger.debug("不加钱")
        end
        pay_success=true
      else
        ps.name="付款未成功"
      end
    else
      ps.memo+="非法"
      ps.name="签名不对"
      logger.debug("签名不对")
    end
    ps.save
    if pay_success
      redirect_to "/tuan/cash_pay_success/"+params[:out_trade_no]
    else
      redirect_to "/tuan/cash_pay_failure/"+params[:out_trade_no]
    end
    
  end
  
#http://www.15-1688.com:3000/tuan/account/alipay/notify?trade_status=TRADE_FINISHED&is_success=T&out_trade_no=201012091136235045&trade_no=1111&total_fee=2020&fee_type=1&attach=&sign=3cc3b8c94797a5f4d060a1fdb95a0301
  def tuan_cash_notify_url_process
    dict={}
    params.each do |k,v|
      if k!="sign" and k!="sign_type" and k!="action" and k!="controller" and v!=""
        dict[k]=v
      end
    end
    logger.debug(dict)
    gen_sign=AlipayLib::gen_sign(dict,"dl5iyfy9ksdiyqvo79sq4m4ztgcv1722")
    logger.debug("-----------------------------------------------------------------")
    logger.debug("gen_sign")
    logger.debug(gen_sign)
    pay_success=false
    ps=PaymentStatus.new
    ps.url=request.request_uri
    ps.ip=request.remote_ip
    ps.from="支付宝"
    ps.tuangou=true
    ps.memo="来自支付宝-团购-现金账户-异步通知接口"
    sn=params[:out_trade_no]
    ps.sn=sn
    if gen_sign==params[:sign]
      co=CashOrder.find_by_sn(sn)
      ps.cash_order_id=co.id
      times=OrderStatus.where(:cash_order_id=>co.id).where(:from=>"支付宝").count
      ps.memo+="。当前为该订单的第#{times+1}次通知"
      ps.transaction_id=params[:trade_no]
      ps.total_fee=params[:total_fee]
      if params[:trade_status]=="TRADE_FINISHED" or params[:trade_status]="TRADE_SUCCESS"
        ps.name="付款成功"
        ps.success=true
        co.cash_order_statuses<<OrderStatus.create(:name=>"订单确认",:value=>2,:tuangou=>true,:from=>"支付宝",:url=>request.fullpath,:ip=>request.remote_ip,:sn=>sn,:memo=>ps.memo)       
        c=OrderStatus.where(:cash_order_id=>co.id).where("`value`>1").count
        if c==1#每次还是记录接收到的请求，但是不重复加钱
          u=co.user
          u.money+=co.money
          u.save
          u.cash_details<< CashDetail.create(:cost=>false,:money=>co.money,:memo=>"充值",:tuangou=>true,:total_money=>u.money,:cash_order_id=>co.id,:sn=>sn)
          u.plus_scores((co.money*10).round,"现金充值奖励积分",true)
          logger.debug("加钱")
          ps.memo+=",加钱"
        else
          logger.debug("不加钱")
          ps.memo+=",不加钱"
        end
        pay_success=true
      else
        ps.name="付款未成功"
      end
    else
      ps.memo+="非法"
      ps.name="签名不对"
      logger.debug("签名不对")
    end
    ps.save
    if pay_success
      render :text=>"success"
    else
      render :text=>"error"
    end
  end
  
  
  
end
