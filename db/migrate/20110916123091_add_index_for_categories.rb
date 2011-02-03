class AddIndexForCategories < ActiveRecord::Migration
  def self.up
	add_index :categories,[:name,:parent_id,:position,:special]
  end

  def self.down
	remove_index :categories,[:name,:parent_id,:position,:special]
  end
end
