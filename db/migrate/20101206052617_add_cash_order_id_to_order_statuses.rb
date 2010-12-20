class AddCashOrderIdToOrderStatuses < ActiveRecord::Migration
  def self.up
    add_column :order_statuses, :cash_order_id, :integer
  end

  def self.down
    remove_column :order_statuses, :cash_order_id
  end
end
