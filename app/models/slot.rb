# coding: utf-8
class Slot < ActiveRecord::Base
  has_and_belongs_to_many :materials
  validates :name,  :presence => true
  validates :category_id,  :presence => true
  validates :location,  :presence => true
  
  validate :no_exist_name_category_id_location

  def no_exist_name_category_id_location
    if self.new_record? and !Slot.find_by_name_and_location_and_category_id(name,location,category_id).nil?
      errors[:base] << "名称_分类id_地点三者联合起来需要唯一"
    end
  end
end

# == Schema Information
#
# Table name: slots
#
#  id          :integer(4)      not null, primary key
#  category_id :integer(4)
#  name        :string(255)
#  location    :string(255)
#  size        :string(255)
#  memo        :text
#  created_at  :datetime
#  updated_at  :datetime
#  kind        :string(255)
#

