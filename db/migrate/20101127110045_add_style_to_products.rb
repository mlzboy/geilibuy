class AddStyleToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :style, :string
  end

  def self.down
    remove_column :products, :style
  end
end
