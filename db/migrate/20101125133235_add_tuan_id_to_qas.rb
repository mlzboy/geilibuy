class AddTuanIdToQas < ActiveRecord::Migration
  def self.up
    add_column :qas, :tuan_id, :integer
  end

  def self.down
    remove_column :qas, :tuan_id
  end
end
