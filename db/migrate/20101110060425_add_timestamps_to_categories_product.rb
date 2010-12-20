class AddTimestampsToCategoriesProduct < ActiveRecord::Migration
  def self.up
    add_timestamps :categories_products
  end

  def self.down
    remove_timestamps :categories_products
  end
end
