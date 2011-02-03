class AddIndexForCategoriesProducts < ActiveRecord::Migration
  def self.up
	add_index :categories_products,:category_id,:name=>"categories_products_category_id"
	add_index :categories_products,:product_id,:name=>"categories_products_product_id"
  end

  def self.down
	remove_index :categories_products,:category_id,:name=>"categories_products_category_id"
	remove_index :categories_products,:product_id,:name=>"categories_products_product_id"
  end
end
