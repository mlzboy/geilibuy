class AddShortnameToUrls < ActiveRecord::Migration
  def self.up
    add_column :urls, :shortname, :string
  end

  def self.down
    remove_column :urls, :shortname
  end
end
