class AddIndexForSlots < ActiveRecord::Migration
  def self.up
	add_index :slots,[:name,:location,:category_id]
  end

  def self.down
	remove_index :slots,[:name,:location,:category_id]
  end
end
