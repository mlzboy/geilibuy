class CashDetail < ActiveRecord::Base
  belongs_to:user
end

# == Schema Information
#
# Table name: cash_details
#
#  id            :integer(4)      not null, primary key
#  user_id       :integer(4)
#  money         :decimal(15, 3)  default(0.0)
#  memo          :text
#  cost          :boolean(1)
#  created_at    :datetime
#  updated_at    :datetime
#  tuangou       :boolean(1)      default(FALSE)
#  total_money   :decimal(15, 3)  default(0.0)
#  order_id      :integer(4)
#  cash_order_id :integer(4)
#  sn            :string(255)
#

