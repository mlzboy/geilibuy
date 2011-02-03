class AddSiteToProductsAndUrlToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :site, :string
    add_column :products, :my_url, :string
    add_column :products, :url_id,:integer
  end

  def self.down
    remove_column :products, :my_url
    remove_column :products, :site
    remove_column :products, :url_id
  end
end
