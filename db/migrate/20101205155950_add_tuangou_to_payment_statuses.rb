class AddTuangouToPaymentStatuses < ActiveRecord::Migration
  def self.up
    add_column :payment_statuses, :tuangou, :boolean,:default=>false
  end

  def self.down
    remove_column :payment_statuses, :tuangou
  end
end
