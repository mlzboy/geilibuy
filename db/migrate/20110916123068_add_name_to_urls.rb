class AddNameToUrls < ActiveRecord::Migration
  def self.up
    add_column :urls, :name, :string
    add_column :urls, :weight, :string
    add_column :urls, :material, :string
    add_column :urls, :size, :string
    add_column :urls, :wrap, :string
    add_column :urls, :stock, :boolean,:default=>true
    add_column :images, :big, :boolean,:default=>false

  end

  def self.down
    remove_column :urls, :name
    remove_column :urls, :weight
    remove_column :urls, :material
    remove_column :urls, :size
    remove_column :urls, :wrap
    remove_column :urls, :stock
    remove_column :images, :big
  end
end
