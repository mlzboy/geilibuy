class AddUrlToPaymentStatuses < ActiveRecord::Migration
  def self.up
    add_column :payment_statuses, :url, :text
  end

  def self.down
    remove_column :payment_statuses, :url
  end
end
