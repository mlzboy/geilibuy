class RemoveArticleCategoriesIdToArticles < ActiveRecord::Migration
  def self.up
    remove_column :articles, :article_categories_id
  end

  def self.down
    add_column :articles, :article_categories_id, :integer
  end
end
