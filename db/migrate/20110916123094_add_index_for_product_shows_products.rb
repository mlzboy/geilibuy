class AddIndexForProductShowsProducts < ActiveRecord::Migration
  def self.up
	add_index :product_shows_products,[:product_id,:product_show_id,:position],:name=>"psp_union_index"
  end

  def self.down
	remove_index :product_shows_products,:name=>"psp_union_index"
  end
end
