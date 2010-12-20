class RemoveMemoToPaymentStatuses < ActiveRecord::Migration
  def self.up
    remove_column :payment_statuses, :memo
  end

  def self.down
    add_column :payment_statuses, :memo, :text
  end
end
