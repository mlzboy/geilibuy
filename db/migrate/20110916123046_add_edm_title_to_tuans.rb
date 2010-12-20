class AddEdmTitleToTuans < ActiveRecord::Migration
  def self.up
    add_column :tuans, :edm_title, :string
  end

  def self.down
    remove_column :tuans, :edm_title
  end
end
