class AddSubTitleToProduct < ActiveRecord::Migration
  def self.up
    add_column :products, :sub_title, :string
    add_column :products, :sale,:integer,:default=>0
    add_column :products, :view,:integer,:default=>0
    add_column :products, :stock,:integer,:default=>0
    add_column :products, :on,:boolean,:default=>1
  end

  def self.down
    remove_column :products, :sub_title
    remove_column :products, :sale
    remove_column :products, :view
    remove_column :products, :stock
    remove_column :products, :on
  end
end
