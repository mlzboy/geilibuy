class AddLocationToUrls < ActiveRecord::Migration
  def self.up
    add_column :urls, :location, :string
    add_column :urls, :package, :string
  end

  def self.down
    remove_column :urls, :location
    remove_column :urls, :package
  end
end
