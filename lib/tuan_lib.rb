#coding:utf-8
module TuanLib
  def tuan_total_price(tuan,num)
    if num.blank? or num.nil?
      num=1
    else
      num=num.to_i
    end
    total_products_price=tuan.pp2*num
    if num<=tuan.dp1_num
      delivery_price=tuan.dp1
    else
      delivery_price=tuan.dp2
    end
    total_products_price+delivery_price
  end
end