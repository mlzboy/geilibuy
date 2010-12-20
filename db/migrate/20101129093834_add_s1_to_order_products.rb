class AddS1ToOrderProducts < ActiveRecord::Migration
  def self.up
    add_column :order_products, :s1, :integer
    add_column :order_products, :score, :boolean
  end

  def self.down
    remove_column :order_products, :s1
  end
end
