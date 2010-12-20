class AddAttachmentSuitePicToProductShow < ActiveRecord::Migration
  def self.up
    add_column :product_shows, :suite_pic_file_name, :string
    add_column :product_shows, :suite_pic_content_type, :string
    add_column :product_shows, :suite_pic_file_size, :integer
    add_column :product_shows, :suite_pic_updated_at, :datetime
  end

  def self.down
    remove_column :product_shows, :suite_pic_file_name
    remove_column :product_shows, :suite_pic_content_type
    remove_column :product_shows, :suite_pic_file_size
    remove_column :product_shows, :suite_pic_updated_at
  end
end
