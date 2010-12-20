class AddSpecialToPayments < ActiveRecord::Migration
  def self.up
    add_column :payments, :special, :boolean,:default=>0
  end

  def self.down
    remove_column :payments, :special
  end
end
