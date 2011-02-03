class ChangeStockToUrls < ActiveRecord::Migration
  def self.up
	change_column :urls,:stock,:boolean,:default=>true
  end

  def self.down
  end
end
