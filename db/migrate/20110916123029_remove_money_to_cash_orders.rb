class RemoveMoneyToCashOrders < ActiveRecord::Migration
  def self.up
    remove_column :cash_orders, :money
    add_column :cash_orders, :money, :decimal,:default=>0.00,:precision=>15,:scale=>3
  end

  def self.down
    add_column :cash_orders, :money, :decimal
    remove_column :cash_orders, :money
  end
end
