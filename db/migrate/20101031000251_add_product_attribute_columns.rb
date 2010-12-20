class AddProductAttributeColumns < ActiveRecord::Migration
  def self.up
    add_column :products, :weight,  :string
    add_column :products, :size  ,  :string
    add_column :products, :material,:string
    add_column :products, :editor,  :text
    add_column :products, :caution,:text
    
  end

  def self.down
    remove_column :products, :weight,  :string
    remove_column :products, :size  ,  :string
    remove_column :products, :material,:string
    remove_column :products, :editor,  :text
    remove_column :products, :caution,:text
  end
end
