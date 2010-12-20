class AddTuangouToOrderProducts < ActiveRecord::Migration
  def self.up
    add_column :order_products, :tuangou, :boolean,:default=>false
  end

  def self.down
    remove_column :order_products, :tuangou
  end
end
