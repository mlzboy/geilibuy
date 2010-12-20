class AddRateToFavorites < ActiveRecord::Migration
  def self.up
    add_column :favorites, :rate, :integer,:default=>0
  end

  def self.down
    remove_column :favorites, :rate
  end
end
