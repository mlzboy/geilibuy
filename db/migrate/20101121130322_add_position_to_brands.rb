class AddPositionToBrands < ActiveRecord::Migration
  def self.up
    add_column :brands, :position, :integer,:default=>0
  end

  def self.down
    remove_column :brands, :position
  end
end
