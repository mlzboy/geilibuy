class AddDeliveryNameToOrders < ActiveRecord::Migration
  def self.up
    remove_column :orders, :delivery
    remove_column :orders, :payment
    add_column :orders, :delivery_name, :string
    add_column :orders, :payment_name, :string
  end

  def self.down
  end
end
