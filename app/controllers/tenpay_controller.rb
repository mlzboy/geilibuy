#coding:utf-8
class TenpayController < ApplicationController
  #http://www.geilibuy.com/tenpay/respond?pay_result=0&sp_billno=201012111559552960&transaction_id=1111&total_fee=2020&fee_type=1&attach=&sign=16CE21ED3865F310DE11E280297C2E0B
  def return_url_process
    dict={}
    dict["cmdno"]="1"
    dict["pay_result"]=params[:pay_result]
    dict["date"]=params[:date]
    dict["transaction_id"]=params[:transaction_id]
    dict["sp_billno"]=params[:sp_billno]
    dict["total_fee"]=params[:total_fee]
    dict["fee_type"]="1"
    dict["attach"]=params[:attach]
    dict["key"]="127a657d140c4b6dae6499bbcb09b2cb"#密钥
    logger.debug("=================tenpay==================")
    logger.debug(dict)
    gen_sign=TenpayLib::gen_sign2(dict)
    logger.debug("gen_sign")
    logger.debug(gen_sign.upcase)
    @show_url="http://www.geilibuy.com/pay_failure"
    ps=PaymentStatus.new
    ps.url=request.request_uri
    ps.ip=request.remote_ip
    ps.from="财付通"
    ps.memo="来自支财付通-同步通知接口"
    sn=dict["sp_billno"]
    ps.sn=sn
   if gen_sign.upcase==params[:sign]
      order=Order.find_by_sn(sn)
      ps.order_id=order.id
      ps.transaction_id=dict["transaction_id"]
      ps.total_fee=(dict["total_fee"].to_f/100).to_s
      times=OrderStatus.where(:order_id=>order.id).where(:from=>"财付通").count
      logger.debug("@@@@@@@@@@@@@@@@@@@@@@-----------------------------")
      ps.memo+="。当前为该订单的第#{times+1}次通知"
      if dict["pay_result"]=="0"
        ps.name="付款成功"
        ps.success=true
        order.order_statuses<<OrderStatus.create(:name=>"订单确认",:value=>2,:from=>"财付通",:url=>request.url,:ip=>request.remote_ip,:sn=>sn,:memo=>ps.memo)
        @show_url="http://www.geilibuy.com/pay_success"
      else
        ps.name="付款未成功"
      end
    else
      ps.name="签名不对"
      ps.memo+="，非法"
      logger.debug("签名不对")
    end
    ps.save
    render "return_url"
  end
#/tuan/tenpay/respond?attach=&bargainor_id=1208746801&cmdno=1&date=20101211&fee_type=1&pay_info=OK&pay_result=0&pay_time=1292001601&sign=E5BDFA02EAEE38C850945FED355FB780&sp_billno=201012110117513531&total_fee=1&transaction_id=1208746801201012110117513531&ver=1
  #http://www.geilibuy.com/tuan/tenpay/respond?pay_result=0&sp_billno=201012111645448600&transaction_id=1111&total_fee=2020&fee_type=1&attach=&sign=DA4645B2794B4B5B6D2C74B7A512F3A9
  def tuan_return_url_process
    dict={}
    #dict["bargainor_id"]="1208746801"
    dict["cmdno"]="1"
    dict["pay_result"]=params[:pay_result]
    dict["date"]=params[:date]
    dict["transaction_id"]=params[:transaction_id]
    dict["sp_billno"]=params[:sp_billno]
    dict["total_fee"]=params[:total_fee]
    dict["fee_type"]="1"
    dict["attach"]=params[:attach]
    dict["key"]="127a657d140c4b6dae6499bbcb09b2cb"#密钥
    logger.debug("=================tenpay==================")
    logger.debug(dict)
    gen_sign=TenpayLib::gen_sign2(dict)
    logger.debug("gen_sign")
    logger.debug(gen_sign.upcase)
    @show_url="http://www.geilibuy.com/tuan/pay_failure/"+dict["sp_billno"]
    ps=PaymentStatus.new
    ps.url=request.request_uri
    ps.ip=request.remote_ip
    ps.from="财付通"
    ps.tuangou=true
    ps.memo="来自支财付通-团购同步通知接口"
    sn=dict["sp_billno"]
    ps.sn=sn
   if gen_sign.upcase==params[:sign]
      order=Order.find_by_sn(sn)
      ps.order_id=order.id
      ps.transaction_id=dict["transaction_id"]
      ps.total_fee=(dict["total_fee"].to_f/100).to_s
      times=OrderStatus.where(:order_id=>order.id).where(:from=>"财付通").count
      ps.memo+="。当前为该订单的第#{times+1}次通知"
      if dict["pay_result"]=="0"
        ps.name="付款成功"
        ps.success=true
        order.order_statuses<<OrderStatus.create(:name=>"订单确认",:value=>2,:tuangou=>true,:from=>"财付通",:url=>request.fullpath,:ip=>request.remote_ip,:memo=>ps.memo,:sn=>sn)       
        tuan=order.tuan
        tuan.current_num+=1
        tuan.save
        @show_url="http://www.geilibuy.com/tuan/pay_success/"+sn
      else
        ps.name="付款未成功"
      end
    else
      ps.name="签名不对"
      ps.memo+="，非法"
      logger.debug("签名不对")
    end
    ps.save
    render "return_url"
  end


  #http://www.geilibuy.com/tuan/account/tenpay/respond?pay_result=0&sp_billno=201012111703201571&transaction_id=1111&total_fee=2020&fee_type=1&attach=&sign=7C4672A3542779FBD899F3A296EA77DC
  def tuan_cash_return_url_process
    dict={}
    dict["cmdno"]="1"
    dict["pay_result"]=params[:pay_result]
    dict["date"]=params[:date]
    dict["transaction_id"]=params[:transaction_id]
    dict["sp_billno"]=params[:sp_billno]
    dict["total_fee"]=params[:total_fee]
    dict["fee_type"]="1"
    dict["attach"]=params[:attach]
    dict["key"]="127a657d140c4b6dae6499bbcb09b2cb"#密钥
    logger.debug("=================tenpay==================")
    logger.debug(dict)
    gen_sign=TenpayLib::gen_sign2(dict)
    logger.debug("gen_sign")
    logger.debug(gen_sign.upcase)
    @show_url="http://www.geilibuy.com/tuan/cash_pay_failure/"+dict["sp_billno"]
    ps=PaymentStatus.new
    ps.url=request.request_uri
    ps.ip=request.remote_ip
    ps.from="财付通"
    ps.tuangou=true
    ps.memo="来自支财付通-团购-现金同步通知接口"
    sn=dict["sp_billno"]
    ps.sn=sn
   if gen_sign.upcase==params[:sign]
      co=CashOrder.find_by_sn(sn)
      ps.cash_order_id=co.id
      ps.transaction_id=dict["transaction_id"]
      ps.total_fee=(dict["total_fee"].to_f/100).to_s
      times=OrderStatus.where(:cash_order_id=>co.id).where(:from=>"财付通").count
      ps.memo+="。当前为该订单的第#{times+1}次通知"
      if dict["pay_result"]=="0"
        ps.name="付款成功"
        ps.success=true
        co.cash_order_statuses<<OrderStatus.create(:name=>"订单确认",:value=>2,:tuangou=>true,:from=>"财付通",:url=>request.fullpath,:ip=>request.remote_ip,:sn=>sn,:memo=>ps.memo)       
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
        end
        @show_url="http://www.geilibuy.com/tuan/cash_pay_success/"+sn
      else
        ps.name="付款未成功"
      end
    else
      ps.memo+="非法"
      ps.name="签名不对"
      logger.debug("签名不对")
    end
    ps.save
    render "return_url"
  end
  
  def query(sn,attach=nil)
    dict={}
    dict["attach"]=attach||""
    dict["bargainor_id"]="1208746801"#商家id
    dict["charset"]="UTF-8"
    dict["cmdno"]=2
    dict["date"]=sn[0,8]
    dict["output_xml"]=1
    dict["sp_billno"]=sn
    dict["transaction_id"]=dict["bargainor_id"]+dict["date"]+sn[-10,10]
    a=dict.clone
    dict["key"]="127a657d140c4b6dae6499bbcb09b2cb"#密钥
    a["sign"]=gen_sign2(dict).upcase
    r="http://mch.tenpay.com/cgi-bin/cfbi_query_order_v3.cgi?"
    #待完成，此接口为post形式
  end

end
