class AddTuangouToPayments < ActiveRecord::Migration
  def self.up
    add_column :payments, :tuangou, :boolean,:default=>false
  end

  def self.down
    remove_column :payments, :tuangou
  end
end
