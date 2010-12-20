class Education < ActiveRecord::Base
  belongs_to:user_detail
end

# == Schema Information
#
# Table name: educations
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

