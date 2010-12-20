class AddTuangouToOrderStatuses < ActiveRecord::Migration
  def self.up
    add_column :order_statuses, :tuangou, :boolean,:default=>false
  end

  def self.down
    remove_column :order_statuses, :tuangou
  end
end
