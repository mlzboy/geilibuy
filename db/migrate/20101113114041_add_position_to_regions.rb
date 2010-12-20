class AddPositionToRegions < ActiveRecord::Migration
  def self.up
    remove_column :regions, :position
    add_column :regions, :position, :integer,:default=>0
  end

  def self.down
  end
end
