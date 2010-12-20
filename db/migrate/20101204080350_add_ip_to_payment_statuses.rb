class AddIpToPaymentStatuses < ActiveRecord::Migration
  def self.up
    add_column :payment_statuses, :ip, :string
  end

  def self.down
    remove_column :payment_statuses, :ip
  end
end
