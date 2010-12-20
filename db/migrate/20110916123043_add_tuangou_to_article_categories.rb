class AddTuangouToArticleCategories < ActiveRecord::Migration
  def self.up
    add_column :article_categories, :tuangou, :boolean,:default=>false
  end

  def self.down
    remove_column :article_categories, :tuangou
  end
end
