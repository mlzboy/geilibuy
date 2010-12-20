class AddRealMoneyToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :real_money, :decimal, :precision => 15, :scale => 3, :default => 0.0
  end

  def self.down
    remove_column :orders, :real_money
  end
end
