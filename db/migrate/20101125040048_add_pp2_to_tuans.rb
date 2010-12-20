class AddPp2ToTuans < ActiveRecord::Migration
  def self.up
    add_column :tuans, :pp2, :decimal,:precision=>15,:scale=>3,:default=>0.0
  end

  def self.down
    remove_column :tuans, :pp2
  end
end
