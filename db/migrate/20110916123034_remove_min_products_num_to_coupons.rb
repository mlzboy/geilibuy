class RemoveMinProductsNumToCoupons < ActiveRecord::Migration
  def self.up
    remove_column :coupons, :min_products_num
    add_column :coupons, :min_products_num, :integer,:default=>0
  end

  def self.down
    add_column :coupons, :min_products_num, :integer
    remove_column :coupons, :min_products_num
  end
end
