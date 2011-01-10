#coding:utf-8
class AccountController < ApplicationController
  layout 'tuan'
  before_filter :tuan_login?,:only=>[:orders,:pay,:charge,:chargepay,:settings,:cash_pay_success]
  before_filter :check_money,:only=>[:pay,:pay_jump]
  before_filter :check_payment,:only=>[:pay_jump]

  def order_cancle
    tuan_order=Order.find_by_sn_and_user_id(params[:sn],current_user.id)
    if tuan_order
      tuan_order.order_statuses<<OrderStatus.create(:name=>"取消",:value=>64,:tuangou=>true)
      u=current_user
      u.plus_scores(tuan_order.cost_scores,"取消订单T#{tuan_order.sn},返还积分",true)#在团购订单中目前不能消费积分，所以不用没关系
      if tuan_order.cash_money>0
        u.money+=tuan_order.cash_money
        u.save
        u.cash_details<< CashDetail.create(:cost=>false,:money=>tuan_order.cash_money.abs,:memo=>"取消订单T#{tuan_order.sn},返还现金",:tuangou=>true,:total_money=>u.money,:order_id=>tuan_order.id)
      end
    end
    redirect_to "/tuan/account/orders"
  end

  def order_detail
    @tuan_order=Order.find_by_sn(params[:sn])
  end
  def cash_pay_failure
    sn=params[:sn]
    @cash_order=CashOrder.find_by_sn_and_user_id(sn,current_user.id)
  end
  def cash_pay_success
    sn=params[:sn]
    @cash_order=CashOrder.find_by_sn_and_user_id(sn,current_user.id)
  end
  def settings
    if request.post?
      u=current_user
      nick=params[:nickname]
      oldpwd=params[:oldpwd]
      newpwd=params[:newpwd]
      u.nick=nick
      flash["info"]="操作成功!"
      if !oldpwd.blank?
        if User.find_by_id_and_password(u.id,oldpwd)
          u.password=newpwd
        else
          flash["info"]="操作失败!"
          return
        end
      end
      u.save

    end
  end
  def charge
  end
  def chargepay
    if request.post?
      money=params[:amount]
      cookies["tuan_cash_money"]={:value=>money.to_s,:domain=>".geilibuy.com"}
    end
  end
  def check_money
    str=cookies["tuan_cash_money"]
    logger.debug("------------------")
    logger.debug(str)
    if str.blank? or str.strip==""
      redirect_to "/tuan/account/charge"
    end
  end

  def check_payment
    str=cookies["tuan_cash_money"]
    logger.debug("------------------")
    logger.debug(str)
    if str.blank? or str.strip==""
      redirect_to "/tuan/account/charge"
    end
  end
  #要前置过滤器检查金额>0
  def pay
      payment_id=params[:payment]
      cookies["tuan_payment_id"]={:value=>payment_id,:expires=>1.year.from_now,:domain=>".geilibuy.com"}
      @payment=Payment.find(payment_id)
  end
  def pay_jump
    #if request.post?
      payment_id=cookies["tuan_payment_id"]
      money=cookies["tuan_cash_money"]
      co=CashOrder.new
      co.user_id=current_user.id
      co.payment_name=Payment.find_by_id(payment_id).name
      co.payment_id=payment_id.to_i
      co.ip=request.remote_ip
      co.sn=gen_order_sn
      co.name="现金充值订单"+co.sn#18位的sn加上7个中文字或是14个英文
      co.description="给力团现金充值"+money+"元,订单编号"+co.sn
      #考虑加attach或body
      co.new_scores=0
      co.money=money.to_f
      co.tuangou=true
      co.save
      #co.cash_order_statuses<<CashOrderStatus.create(:name=>"未确认",:value=>1)
      co.cash_order_statuses<<OrderStatus.create(:name=>"未确认",:value=>1,:tuangou=>true)
      @co=co
    #end
    cookies.delete "tuan_payment_id"
    cookies.delete "tuan_cash_money"
    render :layout=>nil
  end
  def points
    @score_details=ScoreDetail.where(:user_id=>current_user.id).where(:tuangou=>true).order("id desc").all
  end
  def credit
    @cash_details=CashDetail.where(:tuangou=>true).where(:user_id=>current_user.id).order("id desc").all
  end
  def invites
  end
  def orders
    @orders=current_user.tuan_orders
  end

  def login
  end

  def register
  end

  def regok
  end

  def address
    u=User.find_by_email(session["user"]["email"])
    @addresses=u.addresses
  end

  def address_edit
    id=params[:id]
    @address=Address.find_by_user_id_and_id(current_user.id,id)
    unless @address
      redirect_to "tuan/account/address"
    end
  end

  def address_delete
    id=params[:id]
    address=Address.find_by_user_id_and_id(current_user.id,id)
    if address
      address.destroy
    end
    back_url=params[:back_url]
    if !back_url.blank?
      redirect back_url
    else
      redirect_to "/tuan/account/address"
    end
  end

  def use_this_address
    id=params[:address_id]
    address=Address.find_by_user_id_and_id(current_user.id,id)
    address.rate+=1
    address.save
    back_url=params[:back_url]
    if !back_url.blank?
      redirect back_url
    else
      redirect_to "/tuan/order"
    end
  end
end

