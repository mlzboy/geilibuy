class AddCashIdToCashDetails < ActiveRecord::Migration
  def self.up
    add_column :cash_details, :cash_order_id, :integer
  end

  def self.down
    remove_column :cash_details, :cash_order_id
  end
end
