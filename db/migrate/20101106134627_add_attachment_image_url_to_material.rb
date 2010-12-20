class AddAttachmentImageUrlToMaterial < ActiveRecord::Migration
  def self.up
    add_column :materials, :image_url_file_name, :string
    add_column :materials, :image_url_content_type, :string
    add_column :materials, :image_url_file_size, :integer
    add_column :materials, :image_url_updated_at, :datetime
  end

  def self.down
    remove_column :materials, :image_url_file_name
    remove_column :materials, :image_url_content_type
    remove_column :materials, :image_url_file_size
    remove_column :materials, :image_url_updated_at
  end
end
