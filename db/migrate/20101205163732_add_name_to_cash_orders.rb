class AddNameToCashOrders < ActiveRecord::Migration
  def self.up
    add_column :cash_orders, :name, :string
  end

  def self.down
    remove_column :cash_orders, :name
  end
end
