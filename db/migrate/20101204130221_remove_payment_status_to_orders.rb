class RemovePaymentStatusToOrders < ActiveRecord::Migration
  def self.up
    remove_column :orders, :payment_status
    remove_column :orders, :delivery_status
  end

  def self.down
    add_column :orders, :payment_status, :string
    add_column :orders, :delivery_status, :string
  end
end
