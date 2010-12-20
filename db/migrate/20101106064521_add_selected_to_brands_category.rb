class AddSelectedToBrandsCategory < ActiveRecord::Migration
  def self.up
    add_column :brands_categories, :selected, :boolean,:default=>0
    add_column :brands_categories, :position, :integer,:default=>0
  end

  def self.down
    remove_column :brands_categories, :selected
    remove_column :brands_categories, :position
  end
end
