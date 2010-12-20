class AddCouponIdToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :coupon_id, :integer
  end

  def self.down
    remove_column :orders, :coupon_id
  end
end
