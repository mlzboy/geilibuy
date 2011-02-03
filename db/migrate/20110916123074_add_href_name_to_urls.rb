class AddHrefNameToUrls < ActiveRecord::Migration
  def self.up
    add_column :urls, :href_name, :string
  end

  def self.down
    remove_column :urls, :href_name
  end
end
