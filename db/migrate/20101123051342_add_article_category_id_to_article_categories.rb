class AddArticleCategoryIdToArticleCategories < ActiveRecord::Migration
  def self.up
    add_column :articles, :article_category_id, :integer
  end

  def self.down
    remove_column :articles, :article_category_id
  end
end
