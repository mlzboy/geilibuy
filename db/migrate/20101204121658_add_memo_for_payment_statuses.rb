class AddMemoForPaymentStatuses < ActiveRecord::Migration
  def self.up
	add_column :payment_statuses,:memo,:string 
 end

  def self.down
	remove_column :payment_statuses,:memo
  end
end
