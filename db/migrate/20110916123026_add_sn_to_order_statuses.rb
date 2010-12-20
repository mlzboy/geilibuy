class AddSnToOrderStatuses < ActiveRecord::Migration
  def self.up
    add_column :order_statuses, :sn, :string
  end

  def self.down
    remove_column :order_statuses, :sn
  end
end
