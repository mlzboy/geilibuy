class RemoveProductIdToProductShow < ActiveRecord::Migration
  def self.up
    remove_column :product_shows, :product_id
  end

  def self.down
    add_column :product_shows, :product_id, :integer
  end
end
