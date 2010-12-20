class InviteDetail < ActiveRecord::Base
  belongs_to:invite
end

# == Schema Information
#
# Table name: invite_details
#
#  id         :integer(4)      not null, primary key
#  invite_id  :integer(4)
#  name       :string(255)
#  value      :integer(4)      default(1)
#  created_at :datetime
#  updated_at :datetime
#

