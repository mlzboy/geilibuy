class DeliveryStatus < ActiveRecord::Base
  belongs_to:order
end

# == Schema Information
#
# Table name: delivery_statuses
#
#  id         :integer(4)      not null, primary key
#  order_id   :integer(4)
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

