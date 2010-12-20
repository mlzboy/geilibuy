class DeliveryTime < ActiveRecord::Base
  has_many:addresses
end

# == Schema Information
#
# Table name: delivery_times
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  position   :integer(4)      default(0)
#

