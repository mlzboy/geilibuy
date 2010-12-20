#coding:utf-8
class Category < ActiveRecord::Base
  require './lib/paperclip_processors/jcropper.rb'
  include Paperclip
  require 'uuid'
  acts_as_tree :order=>"position"
  scope :_top, where("parent_id is null")
  scope :top,_top.order("position asc")
  scope :sub, where("parent_id is not null")
  scope :normal,where(:special=>false).where(:parent_id=>nil).order("position")
  before_create:add_uuid
  has_and_belongs_to_many:products
  has_and_belongs_to_many:brands
  has_attached_file :i1,:processors => [:jcropper],:styles=>{:show=>"55x55#",:process=>"800x800>"}
  after_update :reprocess_avatar,:if => :cropping?
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h, :crop_f
  validates :name,  :presence => true
  validate:check_same_level_exist_the_same_name?
  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end
    
  def avatar_geometry(field,style = :original)
    @geometry ||= {}
    eval("@geometry[style] ||= Paperclip::Geometry.from_file #{field}.path(style)")
  end
  
  def online_products(product_id)
    self.products.select{|e| e.on==true and e.id!=product_id.to_i}
  end
  
  def online_five_products(product_id)
    Product.find_by_sql ["select * from ((SELECT product_id FROM categories_products where category_id=?) cp inner join products p on p.id=cp.product_id) where `on`=1 and id<>? order by rand(?) limit 0,5",self.id,product_id,product_id]
  end
  
  def all_children_ids()
    ids=[]
    q=[]<<self
    while q.size>0
      c=q.shift
      ids<<c.id
      if c.children.size>0
        q.concat(c.children)
      end
    end
    ids
  end
  
  def top?
    self.ancestors.size==0
  end
  def second?
    self.ancestors.size==1
  end
  def third?
    self.ancestors.size==2
  end
  def whole_categories
    r=self.ancestors.unshift self
    r.reverse
  end
  private
  
  def reprocess_avatar
    eval("#{crop_f}.reprocess!")
  end
  def add_uuid
    self.uuid=UUID.new.generate
  end
  
  def check_same_level_exist_the_same_name?
    if parent_id.nil? or parent_id.blank?
      if self.new_record? and !Category.find(:first,:conditions=>"(parent_id is null or parent_id='') and name='#{name.strip}'").nil?
        errors[:base] << "同一级别名称需要唯一"
      end
    else
      if self.new_record? and !Category.find(:first,:conditions=>"parent_id=#{parent_id} and name='#{name.strip}'").nil?
        errors[:base] << "同一级别名称需要唯一"
      end
    end
    
  end
    

end

# == Schema Information
#
# Table name: categories
#
#  id              :integer(4)      not null, primary key
#  name            :string(255)
#  memo            :text
#  created_at      :datetime
#  updated_at      :datetime
#  uuid            :string(255)
#  parent_id       :integer(4)
#  position        :integer(4)      default(0)
#  special         :boolean(1)      default(FALSE)
#  i1_file_name    :string(255)
#  i1_content_type :string(255)
#  i1_file_size    :integer(4)
#  i1_updated_at   :datetime
#

