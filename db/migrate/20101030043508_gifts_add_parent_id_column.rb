class GiftsAddParentIdColumn < ActiveRecord::Migration
  def self.up
    add_column :gifts,:parent_id,:integer
    add_column:gifts,:position,:integer,:default=>0
    remove_column:gifts,:leaf
    add_column:gifts,:leaf,:boolean,:default=>1
  end

  def self.down
    remove_column :gifts,:parent_id
    remove_column:gifts,:position
    remove_column:gifts,:leaf
    add_column:gifts,:leaf,:boolean
  end
end
