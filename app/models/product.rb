#coding:utf-8
class Product < ActiveRecord::Base
  require './lib/paperclip_processors/jcropper.rb'
  include Paperclip
  belongs_to :brand
  has_many:favorites
  has_and_belongs_to_many :categories,:order => "categories_products.position asc,categories_products.created_at asc"
  has_many:presale_consultings
  has_many:postsale_comments
  has_and_belongs_to_many:gifts
  has_and_belongs_to_many :product_shows
  has_attached_file :i1,:processors => [:jcropper],:styles=>{:mini=>"40x40#",:thumb=>"55x55#",:small=>"100x100#",:medium=>"160x160#",:big=>"400x400#",:process=>"800x800>"}
  has_attached_file :i2,:processors => [:jcropper],:styles=>{:mini=>"40x40#",:thumb=>"55x55#",:small=>"100x100#",:medium=>"160x160#",:big=>"400x400#",:process=>"800x800>"}
  has_attached_file :i3,:processors => [:jcropper],:styles=>{:mini=>"40x40#",:thumb=>"55x55#",:small=>"100x100#",:medium=>"160x160#",:big=>"400x400#",:process=>"800x800>"}
  has_attached_file :i4,:processors => [:jcropper],:styles=>{:mini=>"40x40#",:thumb=>"55x55#",:small=>"100x100#",:medium=>"160x160#",:big=>"400x400#",:process=>"800x800>"}
  after_update :reprocess_avatar,:if => :cropping?
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h, :crop_f
  attr_accessor:category_ids
  #validates :category_ids,  :presence => true
  validate :belongs_to_some_category?
  def belongs_to_some_category?
    if category_ids.blank?
      self.errors[:base]<<"产品至少属于一个分类"
    end
    
    if category_ids.class==[].class
      r=category_ids.select{|e| e.nil? ==false and e.strip!=""}
      self.errors[:base]<<"产品至少属于一个分类" if r.size==0
    end
    
    logger.debug("============categ================")
    logger.debug(category_ids)
  
  end

  def user_last_upload_photo(user_id)
    UploadPhoto.find_by_user_id_and_product_id(user_id,self.id)
  end

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def avatar_geometry(field,style = :original)
    @geometry ||= {}
    eval("@geometry[style] ||= Paperclip::Geometry.from_file #{field}.path(style)")
  end

  def style_products#获取同款的其它产品,不包含自身
    if self.style.blank?
      []
    else
      Product.where(:style=>style).where("id<>#{id}").all
    end

  end

  def Product.below_10
    Product.where(:on=>true).where("p2<10").order("position desc").limit(12).all
  end

  def Product.between_10_and_30
    Product.where(:on=>true).where("p2<=30 and p2>=10").order("position desc").limit(12).all
  end

  def Product.above_50
    Product.where(:on=>true).where("p2>=50").order("position desc").limit(12).all
  end

  def whole_categories
    #获取一个产品对应的一组分类，这组分类应该是position为0的一组，返回的结果按分类的从大类到小类排序的数组
    r=[]
    categories=self.categories
    if categories.size>0
      category=categories[0]
      r=category.ancestors.unshift category
    end
    r=r.reverse
  end
  def postsale_comments_count
    PostsaleComment.where(:product_id=>self.id).where(:hide=>false).count
  end
  private

  def reprocess_avatar
    eval("#{crop_f}.reprocess!")
  end

  def delete_relevent_data
    #检查是否有相关的售前售后

  end
end


# == Schema Information
#
# Table name: products
#
#  id              :integer(4)      not null, primary key
#  name            :string(255)
#  promotion       :boolean(1)      default(FALSE)
#  new             :boolean(1)      default(TRUE)
#  score           :boolean(1)      default(FALSE)
#  description     :text
#  created_at      :datetime
#  updated_at      :datetime
#  i1_file_name    :string(255)
#  i1_content_type :string(255)
#  i1_file_size    :integer(4)
#  i1_updated_at   :datetime
#  i2_file_name    :string(255)
#  i2_content_type :string(255)
#  i2_file_size    :integer(4)
#  i2_updated_at   :datetime
#  i3_file_name    :string(255)
#  i3_content_type :string(255)
#  i3_file_size    :integer(4)
#  i3_updated_at   :datetime
#  i4_file_name    :string(255)
#  i4_content_type :string(255)
#  i4_file_size    :integer(4)
#  i4_updated_at   :datetime
#  weight          :string(255)
#  size            :string(255)
#  material        :string(255)
#  editor          :text
#  caution         :text
#  brand_id        :integer(4)
#  sub_title       :string(255)
#  sale            :integer(4)      default(0)
#  view            :integer(4)      default(0)
#  stock           :integer(4)      default(0)
#  on              :boolean(1)      default(TRUE)
#  wrap            :string(255)
#  s1              :integer(4)      default(0)
#  p1              :decimal(15, 3)  default(0.0)
#  p2              :decimal(15, 3)  default(0.0)
#  p3              :decimal(15, 3)  default(0.0)
#  p4              :decimal(15, 3)  default(0.0)
#  p5              :decimal(15, 3)  default(0.0)
#  memo            :text
#  style           :string(255)
#  position        :integer(4)      default(0)
#  lucky           :integer(4)      default(0)
#  big             :boolean(1)      default(FALSE)
#

