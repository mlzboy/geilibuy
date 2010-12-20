class AddProductCategoryAsscoationTable < ActiveRecord::Migration
  def self.up
   create_table :categories_products, :id => false do |t| #we DO NOT need the id here!
     t.integer :product_id #alternatively, we can write t.references :product
     t.integer :category_id
   end
  end
 
  def self.down
    drop_table :categories_products
  end
end
