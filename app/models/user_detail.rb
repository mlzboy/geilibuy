class UserDetail < ActiveRecord::Base
  belongs_to:user
  has_one:job
  has_one:education
end

# == Schema Information
#
# Table name: user_details
#
#  id           :integer(4)      not null, primary key
#  user_id      :integer(4)
#  gender       :boolean(1)      default(FALSE)
#  job_id       :integer(4)
#  education_id :integer(4)
#  birthday     :datetime
#  introduce    :text
#  created_at   :datetime
#  updated_at   :datetime
#

