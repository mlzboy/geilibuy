class AddTotalFeeToPaymentStatuses < ActiveRecord::Migration
  def self.up
    add_column :payment_statuses, :total_fee, :string
    add_column :payment_statuses, :transaction_id, :string
    add_column :payment_statuses, :sn, :string
  end

  def self.down
    remove_column :payment_statuses, :total_fee
    remove_column :payment_statuses, :transaction_id
    remove_column :payment_statuses, :sn
  end
end
