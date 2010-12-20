class Delivery < ActiveRecord::Base
  has_many:orders
end

# == Schema Information
#
# Table name: deliveries
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  memo       :text
#  position   :integer(4)      default(0)
#  created_at :datetime
#  updated_at :datetime
#  p1         :decimal(15, 3)  default(0.0)
#  special    :boolean(1)      default(FALSE)
#  hide       :boolean(1)      default(FALSE)
#

