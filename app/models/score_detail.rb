class ScoreDetail < ActiveRecord::Base
  belongs_to:user
  
end

# == Schema Information
#
# Table name: score_details
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  score      :integer(4)
#  memo       :text
#  cost       :boolean(1)
#  created_at :datetime
#  updated_at :datetime
#  tuangou    :boolean(1)      default(FALSE)
#

