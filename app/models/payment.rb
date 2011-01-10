class Payment < ActiveRecord::Base
  has_many:orders
  has_many:cash_orders
  has_attached_file :i1#,:url => "/system/:class/:id_partition/:style/:filename",:path => ":rails_root/public/system/:class/:id_partition/:style/:filename"
  acts_as_tree :order=>"position"
  scope :top, where("parent_id is null").order("position")
  #scope :top, _top.order("position")
  #scope :sub, top.("parent_id is not null")
  
  def self.sub
    where("parent_id is not null and hide=0").order("position")
  end
end

# == Schema Information
#
# Table name: payments
#
#  id              :integer(4)      not null, primary key
#  name            :string(255)
#  memo            :text
#  parent_id       :integer(4)
#  position        :integer(4)      default(0)
#  created_at      :datetime
#  updated_at      :datetime
#  i1_file_name    :string(255)
#  i1_content_type :string(255)
#  i1_file_size    :integer(4)
#  i1_updated_at   :datetime
#  hide            :boolean(1)      default(FALSE)
#  code            :string(255)
#  special         :boolean(1)      default(FALSE)
#  tuangou         :boolean(1)      default(FALSE)
#

