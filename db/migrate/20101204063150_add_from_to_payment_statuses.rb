class AddFromToPaymentStatuses < ActiveRecord::Migration
  def self.up
    add_column :payment_statuses, :from, :string
  end

  def self.down
    remove_column :payment_statuses, :from
  end
end
