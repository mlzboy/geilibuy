class AddHideToCoupons < ActiveRecord::Migration
  def self.up
    add_column :coupons, :hide, :boolean,:default=>false
  end

  def self.down
    remove_column :coupons, :hide
  end
end
