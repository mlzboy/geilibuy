class AddFreeShippingToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :free_shipping, :boolean,:default=>false
  end

  def self.down
    remove_column :orders, :free_shipping
  end
end
