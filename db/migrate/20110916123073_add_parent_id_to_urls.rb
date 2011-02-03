class AddParentIdToUrls < ActiveRecord::Migration
  def self.up
    add_column :urls, :parent_ids, :text
  end

  def self.down
    remove_column :urls, :parent_id
  end
end
