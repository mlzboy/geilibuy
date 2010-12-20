class AddTotalMoneyToCashDetails < ActiveRecord::Migration
  def self.up
    add_column :cash_details, :total_money, :decimal,:precision=>15,:default=>0.00,:scale=>3
  end

  def self.down
    remove_column :cash_details, :total_money
  end
end
