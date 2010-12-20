class AddDeliveryToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :delivery, :string
  end

  def self.down
    remove_column :orders, :delivery
  end
end
