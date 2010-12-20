class AddParentIdToArticleCategories < ActiveRecord::Migration
  def self.up
    add_column :article_categories, :parent_id, :integer
  end

  def self.down
    remove_column :article_categories, :parent_id
  end
end
