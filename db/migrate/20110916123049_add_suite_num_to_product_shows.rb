class AddSuiteNumToProductShows < ActiveRecord::Migration
  def self.up
    add_column :product_shows, :suite_num, :integer,:default=>0
    add_column :product_shows, :suite_price, :decimal,:default=>0.00,:precision=>15,:scale=>3
  end

  def self.down
    remove_column :product_shows, :suite_num
    remove_column :product_shows, :suite_price
  end
end
