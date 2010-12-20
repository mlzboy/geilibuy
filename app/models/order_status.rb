class OrderStatus < ActiveRecord::Base
  belongs_to:order
end

# == Schema Information
#
# Table name: order_statuses
#
#  id            :integer(4)      not null, primary key
#  order_id      :integer(4)
#  name          :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  value         :integer(4)      default(1)
#  cash_order_id :integer(4)
#  tuangou       :boolean(1)      default(FALSE)
#  from          :string(255)
#  url           :string(255)
#  ip            :string(255)
#  sn            :string(255)
#  memo          :string(255)
#

