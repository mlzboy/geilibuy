class AddMemoToOrderStatuses < ActiveRecord::Migration
  def self.up
    add_column :order_statuses, :memo, :string
  end

  def self.down
    remove_column :order_statuses, :memo
  end
end
