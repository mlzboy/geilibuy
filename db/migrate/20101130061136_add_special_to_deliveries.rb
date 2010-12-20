class AddSpecialToDeliveries < ActiveRecord::Migration
  def self.up
    add_column :deliveries, :special, :boolean,:default=>0
    add_column :deliveries, :hide, :boolean,:default=>0
  end

  def self.down
    remove_column :deliveries, :special
    remove_column :deliveries, :hide
  end
end
