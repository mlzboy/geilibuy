class AddWrapToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :wrap, :string
  end

  def self.down
    remove_column :products, :wrap
  end
end
