class Invite < ActiveRecord::Base
  belongs_to:user,:foreign_key=>"invited_user_id"
  has_many:invite_details,:order=>"id desc"
  
  def current_status
    self.invite_details.first
  end
end

# == Schema Information
#
# Table name: invites
#
#  id              :integer(4)      not null, primary key
#  tuangou         :boolean(1)      default(FALSE)
#  user_id         :integer(4)
#  invited_user_id :integer(4)
#  ip              :string(255)
#  from            :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#

