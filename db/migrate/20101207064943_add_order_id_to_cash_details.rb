class AddOrderIdToCashDetails < ActiveRecord::Migration
  def self.up
    add_column :cash_details, :order_id, :integer
  end

  def self.down
    remove_column :cash_details, :order_id
  end
end
