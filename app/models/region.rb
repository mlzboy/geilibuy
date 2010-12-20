class Region < ActiveRecord::Base
  scope :provinces, where("parent_id = ?",1)
end

# == Schema Information
#
# Table name: regions
#
#  id        :integer(4)      not null, primary key
#  name      :string(255)
#  parent_id :integer(4)
#  level     :integer(4)
#  position  :integer(4)      default(0)
#

