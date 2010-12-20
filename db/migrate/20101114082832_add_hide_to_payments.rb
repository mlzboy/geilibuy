class AddHideToPayments < ActiveRecord::Migration
  def self.up
    add_column :payments, :hide, :boolean,:default=>0
  end

  def self.down
    remove_column :payments, :hide
  end
end
