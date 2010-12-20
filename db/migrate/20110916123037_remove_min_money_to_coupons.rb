class RemoveMinMoneyToCoupons < ActiveRecord::Migration
  def self.up
    remove_column :coupons, :min_money
    add_column :coupons, :min_money, :decimal,:default=>0.00,:precision=>15,:scale=>3
    remove_column :coupons, :money
    add_column :coupons, :money, :decimal,:default=>0.00,:precision=>15,:scale=>3
  end

  def self.down
  end
end
