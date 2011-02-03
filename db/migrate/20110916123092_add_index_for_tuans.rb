class AddIndexForTuans < ActiveRecord::Migration
  def self.up
	add_index :tuans,[:start_time,:end_time,:on]
  end

  def self.down
	remove_index :tuans,:column=>[:start_time,:end_time,:on]
  end
end
