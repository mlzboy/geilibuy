class AddPositionToCategoriesProduct < ActiveRecord::Migration
  def self.up
    add_column :categories_products, :position, :integer,:default=>0
  end

  def self.down
    remove_column :categories_products, :position
  end
end
