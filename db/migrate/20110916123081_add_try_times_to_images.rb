class AddTryTimesToImages < ActiveRecord::Migration
  def self.up
    add_column :images, :try_times, :integer,:default=>0
  end

  def self.down
    remove_column :images, :try_times
  end
end
