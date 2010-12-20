class AddValueOrderStatuses < ActiveRecord::Migration
  def self.up
    add_column :order_statuses, :value, :integer,:default=>1
    remove_column :orders,:order_status
  end

  def self.down
    remove_column :order_statuses, :value
    add_column :orders,:order_status,:string
  end
end
