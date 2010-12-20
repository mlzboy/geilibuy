class AddEveryoneMaxNumToTuans < ActiveRecord::Migration
  def self.up
    add_column :tuans, :everyone_max_num, :integer,:default=>0
  end

  def self.down
    remove_column :tuans, :everyone_max_num
  end
end
