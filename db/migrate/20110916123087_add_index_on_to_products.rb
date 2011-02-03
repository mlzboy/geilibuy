class AddIndexOnToProducts < ActiveRecord::Migration
  def self.up
	add_index :products,[:on,:promotion,:sale,:new,:stock,:brand_id,:p2,:position],:name=>"products_union_index"
  end

  def self.down
	remove_index :products,:name=>"products_union_index"
  end
end
