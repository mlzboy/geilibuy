class AddDescriptionToCashOrders < ActiveRecord::Migration
  def self.up
    add_column :cash_orders, :description, :text
  end

  def self.down
    remove_column :cash_orders, :description
  end
end
