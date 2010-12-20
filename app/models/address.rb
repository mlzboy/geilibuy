class Address < ActiveRecord::Base
  belongs_to:user
  belongs_to:delivery_time
  belongs_to :province,:class_name=>"Region",:foreign_key=>"province_id"
  belongs_to :city,:class_name=>"Region",:foreign_key=>"city_id"
  belongs_to :district,:class_name=>"Region",:foreign_key=>"district_id"
end

# == Schema Information
#
# Table name: addresses
#
#  id               :integer(4)      not null, primary key
#  consignee        :string(255)
#  province_id      :integer(4)
#  city_id          :integer(4)
#  district_id      :integer(4)
#  address          :string(255)
#  tel              :string(255)
#  mobile           :string(255)
#  delivery_time_id :integer(4)
#  created_at       :datetime
#  updated_at       :datetime
#  zipcode          :string(255)
#  user_id          :integer(4)
#  rate             :integer(4)      default(0)
#

