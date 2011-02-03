class RemoveParentIdsToUrl < ActiveRecord::Migration
  def self.up
    remove_column :urls, :parent_ids
    change_column :urls, :href_name,:text
  end

  def self.down
    add_column :urls, :parent_ids, :text
  end
end
