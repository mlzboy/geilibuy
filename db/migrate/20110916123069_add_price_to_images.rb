class AddPriceToImages < ActiveRecord::Migration
  def self.up
    add_column :urls, :price, :decimal,:precision=>15,:scale=>3,:default=>0.00
  end

  def self.down
    remove_column :urls, :price
  end
end
