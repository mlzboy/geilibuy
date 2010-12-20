class AddP1ToDeliveries < ActiveRecord::Migration
  def self.up
    add_column :deliveries, :p1, :decimal,:default=>0
  end

  def self.down
    remove_column :deliveries, :p1
  end
end
