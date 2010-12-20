class AddHideToBrands < ActiveRecord::Migration
  def self.up
    add_column :brands, :hide, :boolean,:default=>0
  end

  def self.down
    remove_column :brands, :hide
  end
end
