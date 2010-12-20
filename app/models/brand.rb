class Brand < ActiveRecord::Base
  require './lib/paperclip_processors/jcropper.rb'
  include Paperclip
  has_many :products
  has_and_belongs_to_many :categories
  has_attached_file :i1,:processors => [:jcropper],:styles=>{:show=>"179x123#",:process=>"800x800>"}
  has_attached_file :i2,:processors => [:jcropper],:styles=>{:show=>"260x338#",:process=>"800x800>"}
  after_update :reprocess_avatar,:if => :cropping?
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h, :crop_f
  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end
    
  def avatar_geometry(field,style = :original)
    @geometry ||= {}
    eval("@geometry[style] ||= Paperclip::Geometry.from_file #{field}.path(style)")
  end
  
  def rand_five_products
    Product.find_by_sql ["select * from products where brand_id=? order by rand() limit 0,5",self.id]
  end
  
  private
  
  def reprocess_avatar
    eval("#{crop_f}.reprocess!")
  end
end

# == Schema Information
#
# Table name: brands
#
#  id              :integer(4)      not null, primary key
#  name            :string(255)
#  story           :text
#  i1_file_name    :string(255)
#  i1_content_type :string(255)
#  i1_file_size    :integer(4)
#  i1_updated_at   :datetime
#  i2_file_name    :string(255)
#  i2_content_type :string(255)
#  i2_file_size    :integer(4)
#  i2_updated_at   :datetime
#  created_at      :datetime
#  updated_at      :datetime
#  position        :integer(4)      default(0)
#  hide            :boolean(1)      default(FALSE)
#

