class Material < ActiveRecord::Base
  has_and_belongs_to_many :slots
  has_attached_file :image_url,:styles=>{:show=>"150x150>"}
end

# == Schema Information
#
# Table name: materials
#
#  id                     :integer(4)      not null, primary key
#  name                   :string(255)
#  hyperlink              :string(255)
#  title                  :string(255)
#  alt                    :string(255)
#  text                   :string(255)
#  memo                   :text
#  created_at             :datetime
#  updated_at             :datetime
#  image_url_file_name    :string(255)
#  image_url_content_type :string(255)
#  image_url_file_size    :integer(4)
#  image_url_updated_at   :datetime
#  size                   :string(255)
#  kind                   :string(255)
#

