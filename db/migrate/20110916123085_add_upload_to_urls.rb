class AddUploadToUrls < ActiveRecord::Migration
  def self.up
    add_column :urls, :upload, :boolean,:default=>false
  end

  def self.down
    remove_column :urls, :upload
  end
end
