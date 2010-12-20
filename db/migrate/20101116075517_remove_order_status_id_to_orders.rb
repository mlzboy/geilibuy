class RemoveOrderStatusIdToOrders < ActiveRecord::Migration
  def self.up
    remove_column :orders, :order_status_id
    remove_column :orders, :delivery_status_id
    remove_column :orders, :payment_status_id
  end

  def self.down
    add_column :orders, :order_status_id, :integer
    add_column :orders, :delivery_status_id, :integer
    add_column :orders, :payment_status_id, :integer
  end
end
