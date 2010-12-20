class AddOrderIdToCoupons < ActiveRecord::Migration
  def self.up
    add_column :coupons, :order_id, :integer
  end

  def self.down
    remove_column :coupons, :order_id
  end
end
