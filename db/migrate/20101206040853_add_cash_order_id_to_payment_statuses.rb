class AddCashOrderIdToPaymentStatuses < ActiveRecord::Migration
  def self.up
    add_column :payment_statuses, :cash_order_id, :integer
  end

  def self.down
    remove_column :payment_statuses, :cash_order_id
  end
end
