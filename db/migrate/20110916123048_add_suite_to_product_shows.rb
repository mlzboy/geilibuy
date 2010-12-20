class AddSuiteToProductShows < ActiveRecord::Migration
  def self.up
    add_column :product_shows, :suite, :boolean,:default=>false
    add_column :product_shows, :suite_on, :boolean,:default=>false
    add_column :product_shows, :suite_name, :string
  end

  def self.down
    remove_column :product_shows, :suite
    remove_column :product_shows, :suite_on
    remove_column :product_shows, :suite_name
  end
end
