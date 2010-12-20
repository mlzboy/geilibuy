class VoteDetail < ActiveRecord::Base
  belongs_to:vote
end

# == Schema Information
#
# Table name: vote_details
#
#  id         :integer(4)      not null, primary key
#  ip         :string(255)
#  vote_id    :integer(4)
#  user_id    :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

