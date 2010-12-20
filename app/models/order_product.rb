class OrderProduct < ActiveRecord::Base
  belongs_to:product
  belongs_to:order
end

# == Schema Information
#
# Table name: order_products
#
#  id          :integer(4)      not null, primary key
#  name        :string(255)
#  product_id  :integer(4)
#  order_id    :integer(4)
#  num         :integer(4)
#  promotion   :boolean(1)      default(FALSE)
#  p1          :decimal(15, 3)  default(0.0)
#  p2          :decimal(15, 3)  default(0.0)
#  p3          :decimal(15, 3)  default(0.0)
#  p4          :decimal(15, 3)  default(0.0)
#  p5          :decimal(15, 3)  default(0.0)
#  sub_title   :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  cost_scores :integer(4)      default(0)
#  new_scores  :integer(4)      default(0)
#  user_id     :integer(4)
#  s1          :integer(4)
#  score       :boolean(1)
#  tuangou     :boolean(1)      default(FALSE)
#

