class AddLuckyToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :lucky, :integer,:default=>0
    add_column :products, :big, :boolean,:default=>false
  end

  def self.down
    remove_column :products, :lucky
    remove_column :products, :big
  end
end
