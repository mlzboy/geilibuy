class AddS1ToProducts < ActiveRecord::Migration
  def self.up
    remove_column :products, :s1
    add_column :products, :s1, :integer,:default=>0
  end

  def self.down
    remove_column :products, :s1
  end
end
