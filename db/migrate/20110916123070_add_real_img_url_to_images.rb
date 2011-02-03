class AddRealImgUrlToImages < ActiveRecord::Migration
  def self.up
    add_column :images, :real_img_url, :string
  end

  def self.down
    remove_column :images, :real_img_url
  end
end
