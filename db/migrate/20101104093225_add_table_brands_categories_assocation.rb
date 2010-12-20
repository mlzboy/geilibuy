class AddTableBrandsCategoriesAssocation < ActiveRecord::Migration
  def self.up
   create_table :brands_categories, :id => false do |t| #we DO NOT need the id here!
     t.integer :brand_id #alternatively, we can write t.references :product
     t.integer :category_id
   end
  end
 
  def self.down
    drop_table :brands_categories
  end
end
