class AddSuccessToPaymentStatuses < ActiveRecord::Migration
  def self.up
    add_column :payment_statuses, :success, :boolean,:default=>0
  end

  def self.down
    remove_column :payment_statuses, :success
  end
end
