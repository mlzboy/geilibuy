class AddMemoToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :memo, :text
  end

  def self.down
    remove_column :orders, :memo
  end
end
