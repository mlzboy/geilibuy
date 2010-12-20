class AddGiftsProductsAssocationTable < ActiveRecord::Migration
  def self.up
   create_table :gifts_products, :id => false do |t| #we DO NOT need the id here!
     t.integer :product_id #alternatively, we can write t.references :product
     t.integer :gift_id
   end
  end
 
  def self.down
    drop_table :gifts_products
  end
end
