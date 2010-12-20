class Subscription < ActiveRecord::Base
end

# == Schema Information
#
# Table name: subscriptions
#
#  id         :integer(4)      not null, primary key
#  email      :string(255)
#  subscribe  :boolean(1)      default(TRUE)
#  tuan       :boolean(1)      default(TRUE)
#  created_at :datetime
#  updated_at :datetime
#

