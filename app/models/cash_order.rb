class CashOrder < ActiveRecord::Base
  has_many:cash_order_statuses,:class_name=>"OrderStatus",:foreign_key=>"cash_order_id"
  belongs_to:payment
  belongs_to:user
end

# == Schema Information
#
# Table name: cash_orders
#
#  id           :integer(4)      not null, primary key
#  sn           :string(255)
#  user_id      :integer(4)
#  tuangou      :boolean(1)      default(FALSE)
#  payment_id   :integer(4)
#  ip           :string(255)
#  payment_name :string(255)
#  new_scores   :integer(4)      default(0)
#  created_at   :datetime
#  updated_at   :datetime
#  name         :string(255)
#  description  :text
#  money        :decimal(15, 3)  default(0.0)
#

