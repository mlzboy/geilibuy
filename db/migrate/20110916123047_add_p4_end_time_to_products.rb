class AddP4EndTimeToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :p4_end_time, :datetime
  end

  def self.down
    remove_column :products, :p4_end_time
  end
end
