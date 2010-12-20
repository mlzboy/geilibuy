class AddSizeToMaterial < ActiveRecord::Migration
  def self.up
    add_column :materials, :size, :string
  end

  def self.down
    remove_column :materials, :size
  end
end
