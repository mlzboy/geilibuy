class Vote < ActiveRecord::Base
  acts_as_tree :order=>"position"
  scope :_top, where("parent_id is null")
  scope :top,_top.order("position asc")
  has_many:vote_details
end

# == Schema Information
#
# Table name: votes
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  position   :integer(4)      default(0)
#  parent_id  :integer(4)
#  created_at :datetime
#  updated_at :datetime
#

