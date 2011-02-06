class Coupon < ActiveRecord::Base
  belongs_to:order
  belongs_to:user
end

# == Schema Information
#
# Table name: coupons
#
#  id               :integer(4)      not null, primary key
#  name             :string(255)
#  money            :integer(10)
#  start_time       :datetime
#  end_time         :datetime
#  user_id          :integer(4)
#  status           :string(255)
#  kind             :string(255)
#  code             :string(255)
#  from             :string(255)
#  min_money        :integer(10)
#  min_products_num :integer(4)
#  memo             :text
#  created_at       :datetime
#  updated_at       :datetime
#

