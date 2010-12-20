#coding:utf-8
class Order < ActiveRecord::Base
  #has_many:order_statuses,:order=>"`value` asc,`created_at` asc"
  has_many:order_statuses,:order=>"`created_at` asc"
  belongs_to:payment
  belongs_to:delivery
  has_many:payment_statuses
  has_many:delivery_statuses
  has_many:order_products
  belongs_to:user
  belongs_to:tuan
  belongs_to:delivery_company
  has_one:coupon
  has_many:order_suites
  def current_order_status
    self.order_statuses.last
  end
  def order_status
    self.order_statuses.last.name
  end
  def products
    r=[]
    self.order_products.each do |order_product|
      r << order_product.product
    end
    r
  end
  #用于cron过期团购订单处理
  def Order.tuan_expired
    count=0
    Order.where(:tuangou=>true).each do |tuan_order|
      count+=1
      #if tuan_order.current_order_status.created_at+16.days < Time.now
      if tuan_order.current_order_status.value==1 and tuan_order.created_at+1.days < Time.now
        tuan_order.order_statuses<<OrderStatus.create(:name=>"过期",:value=>128,:tuangou=>true)
        u=tuan_order.user
        u.plus_scores(tuan_order.cost_scores,"过期订单T#{tuan_order.sn},返还积分",true)#在团购订单中目前不能消费积分，所以不用没关系
        if tuan_order.cash_money>0
          u.money+=tuan_order.cash_money
          u.save
          u.cash_details<< CashDetail.create(:cost=>false,:money=>tuan_order.cash_money.abs,:memo=>"过期订单T#{tuan_order.sn},返还现金",:tuangou=>true,:total_money=>u.money,:order_id=>tuan_order.id)
        end
      end
    end
    logger.debug("count:"+count.to_s)
  end
  #用于cron过期普通订单处理
  def Order.expired
    count=0
    Order.where(:tuangou=>false).each do |tuan_order|
      count+=1
      #if tuan_order.current_order_status.created_at+16.days < Time.now
      if tuan_order.current_order_status.value==1 and tuan_order.created_at+15.days < Time.now
        tuan_order.order_statuses<<OrderStatus.create(:name=>"过期",:value=>128,:tuangou=>true)
        u=tuan_order.user
        u.plus_scores(tuan_order.cost_scores,"过期订单#{tuan_order.sn},返还积分",false)#在团购订单中目前不能消费积分，所以不用没关系
        if tuan_order.cash_money>0
          u.money+=tuan_order.cash_money
          u.save
          u.cash_details<< CashDetail.create(:cost=>false,:money=>tuan_order.cash_money.abs,:memo=>"过期订单#{tuan_order.sn},返还现金",:tuangou=>false,:total_money=>u.money,:order_id=>tuan_order.id)
        end
      end
    end
    logger.debug("count:"+count.to_s)
  end
  def Order.dispatch_new_scores
    Order.where(:dispatch_scores=>false).all.each do |order|
      if order.new_scores<=0
        order.dispatch_scores=true
        order.save
        #return
        next
      end
      #使用现金账户不会返还积分
      if order.current_order_status.value>1 and order.current_order_status.value<64 and order.created_at+31.days <= Time.now
        order.dispatch_scores=true
        if order.tuangou
          logger.debug("ddd---------->>>>>>>>>>>>>TTTTTTTTTTTTTTDDDDDDDDDDDDDDdd")
          order.user.plus_scores(order.new_scores,"团购订单T#{order.sn}，奖励积分",true)
        else
          logger.debug("RRRRRRRRRRRRRRRRRRRRddd---------->>>>>>>>>>>>>TTTTTTTTTTTTTTDDDDDDDDDDDDDDdd")

          order.user.plus_scores(order.new_scores,"订单#{order.sn}，奖励积分",false)
        end
        order.save
      end
    end
  end
  #对于退货的处理，后续实现，也要实现返还现金，
end


# == Schema Information
#
# Table name: orders
#
#  id                    :integer(4)      not null, primary key
#  user_id               :integer(4)
#  sn                    :string(255)
#  ip                    :string(255)
#  payment_id            :integer(4)
#  delivery_id           :integer(4)
#  products_price        :decimal(15, 3)  default(0.0)
#  total_price           :decimal(15, 3)  default(0.0)
#  delivery_price        :decimal(15, 3)  default(0.0)
#  products_num          :integer(4)      default(0)
#  consignee             :string(255)
#  province              :string(255)
#  city                  :string(255)
#  district              :string(255)
#  address               :string(255)
#  tel                   :string(255)
#  mobile                :string(255)
#  delivery_time         :string(255)
#  created_at            :datetime
#  updated_at            :datetime
#  delivery_name         :string(255)
#  payment_name          :string(255)
#  real_money            :decimal(15, 3)  default(0.0)
#  memo                  :text
#  cost_scores           :integer(4)      default(0)
#  new_scores            :integer(4)      default(0)
#  tuan_id               :integer(4)
#  delivery_company_id   :integer(4)
#  delivery_company_name :string(255)
#  delivery_no           :string(255)
#  product_rank          :integer(4)      default(-2)
#  tuangou               :boolean(1)      default(FALSE)
#  delivery_rank         :integer(4)      default(-2)
#  package_rank          :integer(4)      default(-2)
#  tuan_comment          :text
#  comment               :text
#  cash_money            :decimal(15, 3)  default(0.0)
#  dispatch_scores       :boolean(1)      default(FALSE)
#

