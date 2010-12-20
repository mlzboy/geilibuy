class AddIpToOrderStatuses < ActiveRecord::Migration
  def self.up
    add_column :order_statuses, :ip, :string
  end

  def self.down
    remove_column :order_statuses, :ip
  end
end
