class RemoveTougouToCashDetails < ActiveRecord::Migration
  def self.up
    remove_column :cash_details, :tougou
    add_column :cash_details, :tuangou, :boolean,:default=>false
  end

  def self.down
    add_column :cash_details, :tougou, :boolean
    remove_column :cash_details, :tuangou
  end
end
