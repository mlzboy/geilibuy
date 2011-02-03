class AddProductIdToUrls < ActiveRecord::Migration
  def self.up
    remove_column :urls, :product_id
    add_column :urls, :product_id, :integer
  end

  def self.down
    remove_column :urls, :product_id
  end
end
