#coding:utf-8
require "./lib/common.rb"
class Tuan < ActiveRecord::Base
  has_attached_file :i1,:styles=>{:index=>"231x139",:small=>"100x100#",:medium=>"200x131#",:big=>"439x265#",:process=>"800x800>"},:url => "/system/:class/:id_partition/:style/:filename",:path => ":rails_root/public/system/:class/:id_partition/:style/:filename"
  belongs_to:product
  has_many:tuan_details,:dependent => :destroy
  #attr_accessor:tuan_num
  def Tuan.today
    #Tuan.find_by_sql(["select * from tuans where end_time > ? and `on`=1 order by end_time asc limit 0,1",Time.now]).first
    Tuan.find_by_sql(["select * from tuans where start_time < ? and `on`=1 order by id desc limit 0,1",Time.now]).first

  end
  
  def Tuan.day(yyyymmdd)
    if yyyymmdd =~ /(\d{4})(\d{2})(\d{2})/
	yyyy,mm,dd = yyyymmdd.scan(/(\d{4})(\d{2})(\d{2})/)[0]
        t=Time.local(yyyy,mm,dd)
        #sql=["select * from tuans where start_time >=? and end_time<=? and `on`=1 limit 0,1",t,t.end_of_day()]
        sql=["select * from tuans where start_time >=? and `on`=1 order by id asc limit 0,1",t]
        logger.debug("TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTtt")
        logger.debug(sql[0])
        r=Tuan.find_by_sql(sql).first
    end
  end
  
  def left_time
    #diff = Time.now.end_of_day() - Time.now
    logger.debug("$$$$$$$$$$$$$$$$$$$$$$4444")
    logger.debug(self.end_time)
    logger.debug(Time.now)
    diff=self.end_time-Time.now
    hours = diff.to_i / (60 * 60)
    diff -= hours * (60 * 60)
    minutes = diff.to_i / 60
    diff -= minutes * 60
    seconds = diff.to_i
    
    hours="0"+hours.to_s
    hours=hours[-2,2]
    minutes="0"+minutes.to_s
    minutes=minutes[-2,2]
    seconds="0"+seconds.to_s
    seconds=seconds[-2,2]
    r=":#{hours}:#{minutes}:#{seconds}"
  end
  def details
    TuanDetail.where(:kind=>"detail").where(:tuan_id=>self.id).order("position")
  end
  
  def tips
    TuanDetail.where(:kind=>"tip").where(:tuan_id=>self.id).order("position")
  end
  
  def features
    TuanDetail.where(:kind=>"feature").where(:tuan_id=>self.id).order("position")
  end
  
  def selling?
    if self.end_time>Time.now
      if self.max_num>0
	if self.current_num < self.max_num
	  return true
	else
	  return false
	end
      else
	return true
      end
    else
      return false
    end
  end
  
  def sellout?
    self.max_num>0 and self.current_num>=self.max_num
  end
  
  def end?
    !selling?
  end
  
  def check_buy_num(num)
    if num.nil? or num.blank?
      num=1
    else
      num=num.to_i
    end
    buy_num=1
    if everyone_max_num==0 or everyone_max_num>=num
      buy_num=num
    else
      buy_num=everyone_max_num
    end
    buy_num
  end
  
  def free_shipping?(num)
    buy_num=check_buy_num(num)
    if dp1_num>=buy_num
      dp1>0 ? false : true
    elsif dp2_num<=buy_num
      dp2>0 ? false : true
    end
  end
  
  def shipping_fee(num)
    buy_num=check_buy_num(num)
    if dp1_num>=buy_num
      dp1>0 ? dp1 : 0   
    elsif dp2_num<=buy_num
      dp2>0 ? dp2 : 0        
    end
  end
  
  def total_price(num)
    buy_num=check_buy_num(num)
    shipping_fee(buy_num)+pp2*buy_num
  end
  
  def total_products_price(num)
    buy_num=check_buy_num(num)
    pp2*buy_num
  end
  
  def get_new_scores(num)
    buy_num=check_buy_num(num)
    pp2.round*buy_num*10
  end
  
  def real_money(num,payment,money)
      buy_num=check_buy_num(num)
      r=total_price(buy_num)
      if money>0
        if money < self.total_price(buy_num)
          r=self.total_price(buy_num)-money
        else
          if payment.name=="现金账户"
            r=0
          end
        end
      end
      r
  end
  
  def saled_num
    count=0
    Order.where(:tuan_id=>self.id).all.each do |order|
      if order.current_order_status.value>=2
	count+=1
      end
    end
    count
  end

  def cash_money(num,payment,money)
    buy_num=check_buy_num(num)
    total_price(buy_num)-real_money(num,payment,money)
  end
  
  def url
    "/tuan/deals/#{self.start_time.strftime("%Y%m%d")}"
  end
  
  def href(sn)
    "<a href='#{self.url}'>#{sn}</a>"
  end
  

end

# == Schema Information
#
# Table name: tuans
#
#  id               :integer(4)      not null, primary key
#  product_id       :integer(4)
#  status           :string(255)     default("抢购")
#  pp1              :decimal(15, 3)  default(0.0)
#  dp1              :decimal(15, 3)  default(0.0)
#  dp1_num          :integer(4)      default(1)
#  integer          :integer(4)      default(2)
#  dp2              :decimal(15, 3)  default(0.0)
#  dp2_num          :integer(4)      default(2)
#  title            :string(255)
#  start_time       :datetime
#  end_time         :datetime
#  min_time         :datetime
#  min_num          :integer(4)      default(10)
#  max_time         :datetime
#  max_num          :integer(4)      default(0)
#  on               :boolean(1)      default(TRUE)
#  ts1              :text
#  ts1_name         :string(255)
#  ts2              :text
#  ts2_name         :string(255)
#  ts3              :text
#  ts3_name         :string(255)
#  ws1              :text
#  created_at       :datetime
#  updated_at       :datetime
#  i1_file_name     :string(255)
#  i1_content_type  :string(255)
#  i1_file_size     :integer(4)
#  i1_updated_at    :datetime
#  pp2              :decimal(15, 3)  default(0.0)
#  current_num      :integer(4)      default(0)
#  sub_title        :string(255)
#  everyone_max_num :integer(4)      default(0)
#

