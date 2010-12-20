class DropToCashOrderStatuses < ActiveRecord::Migration
  def self.up
	drop_table :cash_order_statuses  
end

  def self.down
  end
end
