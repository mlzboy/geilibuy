class ModifyTypeColumnNameToKind < ActiveRecord::Migration
  def self.up
    add_column :product_shows,:kind,:string
    remove_column :product_shows,:type
    add_column :materials,:kind,:string
    remove_column :materials,:type
    add_column :slots,:kind,:string
    remove_column :slots,:type
    
  end

  def self.down
    add_column :product_shows,:type,:string
    add_column :materials,:type,:string
    add_column :slots,:type,:string
    remove_column :product_shows,:kind
    remove_column :materials,:kind
    remove_column :slots,:kind
  end
end
