class RemoveTeimstampsToRegions < ActiveRecord::Migration
  def self.up
      remove_column :regions,:created_at
      remove_column :regions,:updated_at
  end

  def self.down
  end
end
