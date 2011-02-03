class AddUploadToImages < ActiveRecord::Migration
  def self.up
    add_column :images, :upload, :boolean,:default=>false
  end

  def self.down
    remove_column :images, :upload
  end
end
