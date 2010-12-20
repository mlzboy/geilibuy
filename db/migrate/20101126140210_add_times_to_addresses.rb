class AddTimesToAddresses < ActiveRecord::Migration
  def self.up
    add_column :addresses, :rate, :integer,:default=>0
  end

  def self.down
    remove_column :addresses, :rate
  end
end
