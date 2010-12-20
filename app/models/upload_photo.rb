class UploadPhoto < ActiveRecord::Base
  belongs_to:user
  belongs_to:product
  has_attached_file :i1,:styles=>{:small=>"100x100>"}
  def specific_product_count()
    UploadPhoto.where(:user_id=>self.user_id).where(:product_id=>self.product_id).count()
  end
end

# == Schema Information
#
# Table name: upload_photos
#
#  id              :integer(4)      not null, primary key
#  user_id         :integer(4)
#  product_id      :integer(4)
#  hide            :boolean(1)      default(TRUE)
#  memo            :text
#  created_at      :datetime
#  updated_at      :datetime
#  i1_file_name    :string(255)
#  i1_content_type :string(255)
#  i1_file_size    :integer(4)
#  i1_updated_at   :datetime
#

