class AddUnitToUrls < ActiveRecord::Migration
  def self.up
    add_column :urls, :unit, :string
  end

  def self.down
    remove_column :urls, :unit
  end
end
