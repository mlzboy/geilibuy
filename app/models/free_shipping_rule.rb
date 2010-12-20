class FreeShippingRule < ActiveRecord::Base
  
  def FreeShippingRule.current
    FreeShippingRule.where("start_time < '#{Time.now}'").where("end_time > '#{Time.now}'").first
  end

end
