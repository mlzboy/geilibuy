class AddCouponMoneyToOrders < ActiveRecord::Migration
  def self.up
    add_column :orders, :coupon_money, :decimal,:default=>0.00,:precision=>15,:scale=>3
  end

  def self.down
    remove_column :orders, :coupon_money
  end
end
