class AddPositionToDeliveryTimes < ActiveRecord::Migration
  def self.up
    add_column :delivery_times, :position, :integer,:default=>0
  end

  def self.down
    remove_column :delivery_times, :position
  end
end
