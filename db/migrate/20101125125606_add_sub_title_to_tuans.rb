class AddSubTitleToTuans < ActiveRecord::Migration
  def self.up
    add_column :tuans, :sub_title, :string
  end

  def self.down
    remove_column :tuans, :sub_title
  end
end
