class LotteryDetail < ActiveRecord::Base
  belongs_to:product
  belongs_to:user
end

# == Schema Information
#
# Table name: lottery_details
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  say        :text
#  big        :boolean(1)
#  ip         :string(255)
#  created_at :datetime
#  updated_at :datetime
#  product_id :integer(4)
#

