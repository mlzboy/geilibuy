class RemoveP1ToProducts < ActiveRecord::Migration
  def self.up
    #remove_column :products, :p1
    #remove_column :products, :p2
    #remove_column :products, :p3
    #remove_column :products, :p4
    #remove_column :products, :p5
    add_column :products, :p1,:decimal,:precision => 15, :scale => 3, :default => 0.00
    add_column :products, :p2,:decimal,:precision => 15, :scale => 3, :default => 0.00
    add_column :products, :p3,:decimal,:precision => 15, :scale => 3, :default => 0.00
    add_column :products, :p4,:decimal,:precision => 15, :scale => 3, :default => 0.00
    add_column :products, :p5,:decimal,:precision => 15, :scale => 3, :default => 0.00
    add_column :products, :memo,:text
  end

  def self.down
  end
end
