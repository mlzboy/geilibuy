class RemoveP1ToDeliveries < ActiveRecord::Migration
  def self.up
    remove_column :deliveries, :p1
    add_column :deliveries, :p1, :decimal, :precision => 15, :scale => 3,:default=>0.00
    
  end

  def self.down
  end
end
