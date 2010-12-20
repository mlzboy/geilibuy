class AddCurrentNumToTuans < ActiveRecord::Migration
  def self.up
    add_column :tuans, :current_num, :integer,:default=>0
  end

  def self.down
    remove_column :tuans, :current_num
  end
end
