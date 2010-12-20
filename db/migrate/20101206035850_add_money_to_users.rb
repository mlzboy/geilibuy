class AddMoneyToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :money, :decimal,:precision=>15,:scale=>3,:default=>0.00
  end

  def self.down
    remove_column :users, :money
  end
end
