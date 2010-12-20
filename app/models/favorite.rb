class Favorite < ActiveRecord::Base
  belongs_to:product
  belongs_to:user
end

# == Schema Information
#
# Table name: favorites
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  product_id :integer(4)
#  created_at :datetime
#  updated_at :datetime
#  rate       :integer(4)      default(0)
#

