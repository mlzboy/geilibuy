class RenameMyUrlToProducts < ActiveRecord::Migration
  def self.up
	rename_column :products,:my_url,:myurl
  end

  def self.down
	rename_column :products,:myurl,:my_url
  end
end
