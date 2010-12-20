class Qa < ActiveRecord::Base
  belongs_to:user
end

# == Schema Information
#
# Table name: qas
#
#  id         :integer(4)      not null, primary key
#  user_id    :integer(4)
#  question   :text
#  answer     :text
#  created_at :datetime
#  updated_at :datetime
#  hide       :boolean(1)      default(FALSE)
#  ip         :string(255)
#  tuan_id    :integer(4)
#

