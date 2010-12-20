class Gift < ActiveRecord::Base
  require 'uuid'
  acts_as_tree :order=>"position"
  scope :top, where("parent_id is null")
  scope :sub, where("parent_id is not null")
  before_create:add_uuid
  after_save:check_leaf
  has_and_belongs_to_many:products
  private
    def add_uuid
      self.uuid=UUID.new.generate
    end
    
    def check_leaf
      if !self.parent.nil?
        self.parent.leaf=false
        self.parent.save
      end
    end
end

# == Schema Information
#
# Table name: gifts
#
#  id         :integer(4)      not null, primary key
#  name       :string(255)
#  memo       :text
#  uuid       :string(255)
#  created_at :datetime
#  updated_at :datetime
#  parent_id  :integer(4)
#  position   :integer(4)      default(0)
#  leaf       :boolean(1)      default(TRUE)
#

