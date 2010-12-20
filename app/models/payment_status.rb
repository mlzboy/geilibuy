class PaymentStatus < ActiveRecord::Base
  belongs_to:order
end

# == Schema Information
#
# Table name: payment_statuses
#
#  id             :integer(4)      not null, primary key
#  order_id       :integer(4)
#  name           :string(255)
#  created_at     :datetime
#  updated_at     :datetime
#  from           :string(255)
#  total_fee      :string(255)
#  transaction_id :string(255)
#  sn             :string(255)
#  url            :text
#  success        :boolean(1)      default(FALSE)
#  ip             :string(255)
#  memo           :string(255)
#  tuangou        :boolean(1)      default(FALSE)
#  cash_order_id  :integer(4)
#

