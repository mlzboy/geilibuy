class AddSuitePicToProductShows < ActiveRecord::Migration
  def self.up
    add_column :product_shows, :suite_pic, :string
  end

  def self.down
    remove_column :product_shows, :suite_pic
  end
end
