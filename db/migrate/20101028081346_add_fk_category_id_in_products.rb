class AddFkCategoryIdInProducts < ActiveRecord::Migration
  def self.up
    add_column :products,:category_id,:integer
    add_index  :products, :category_id
  end

  def self.down
    remove_column :products,:category_id
    remove_index  :products,:category_id

  end
end
