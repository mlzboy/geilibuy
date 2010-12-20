class User < ActiveRecord::Base
  has_many:presale_consultings
  has_many:postsale_comments
  has_many:addresses,:order=>"updated_at desc"
  has_many:orders
  has_many:qas
  has_many:score_details,:order=>"id desc"
  has_many:favorites
  has_one:user_detail
  has_many:cash_details
  has_many:invites
  
  def tuan_orders
    Order.where(:user_id=>self.id).where("tuan_id is not null").order("id desc").all
  end
  
  def plus_scores(scores,reason,tuangou=false,order_id=nil,cash_order_id=nil)
    return if scores==0
    ScoreDetail.create(:memo=>reason,:user_id=>self.id,:cost=>false,:score=>scores.to_i.abs,:tuangou=>tuangou,:order_id=>order_id,:cash_order_id=>cash_order_id)
    u=User.find_by_id(self.id)
    u.score+=scores
    u.save
  end
  
  def minus_scores(scores,reason,tuangou=false,order_id=nil,cash_order_id=nil)
    return if scores==0
    scores=scores.to_i
    if scores>0
      scores=-scores
    end
    ScoreDetail.create(:memo=>reason,:user_id=>self.id,:cost=>true,:score=>scores.to_i.abs,:tuangou=>tuangou,:order_id=>order_id,:cash_order_id=>cash_order_id)
    u=User.find_by_id(self.id)
    u.score+=scores
    u.save    
  end
  
  #def plus_money(cash_money,reason,order_id=nil,cash_order_id=nil,tuangou=false)
  #  return if cash_money==0
  #  u.money+=cash_money
  #  u.save
  #  if cash_money>0
  #    cost=
  #  end
  #  u.cash_details<< CashDetail.create(:cost=>cost,:money=>cash_money.abs,:memo=>reason,:tuangou=>tuangou,:total_money=>u.money,:cash_order_id=>cash_order_id,:order_id=>order_id)
  #end
  
  def un_evalute_tuan_orders_num
    count=0
    self.orders.each do |order|
      if order.tuangou and order.current_order_status.value >1 and order.current_order_status.value<64 and order.product_rank==-2
        count+=1
      end
    end
    count
  end
  
  def already_tuan_ordered?(tuan)
    r=false
    Order.where(:user_id=>self.id).where(:tuangou=>true).where(:tuan_id=>tuan.id).all.each do |tuan_order|
      if tuan_order.current_order_status.value==1
	r=true
      end
    end
    r
  end
  


  
end

# == Schema Information
#
# Table name: users
#
#  id           :integer(4)      not null, primary key
#  email        :string(255)
#  password     :string(255)
#  active       :boolean(1)
#  active_code  :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  nick         :string(255)
#  score        :integer(4)      default(0)
#  lucky        :integer(4)      default(0)
#  money        :decimal(15, 3)  default(0.0)
#  return_money :decimal(15, 3)  default(0.0)
#

