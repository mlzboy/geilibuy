class AddHrefNameToProducts < ActiveRecord::Migration
  def self.up
    add_column :products, :href_name, :string
  end

  def self.down
    remove_column :products, :href_name
  end
end
