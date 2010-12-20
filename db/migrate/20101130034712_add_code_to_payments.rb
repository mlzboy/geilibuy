class AddCodeToPayments < ActiveRecord::Migration
  def self.up
    add_column :payments, :code, :string
  end

  def self.down
    remove_column :payments, :code
  end
end
