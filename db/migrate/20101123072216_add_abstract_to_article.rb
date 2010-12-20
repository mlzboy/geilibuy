class AddAbstractToArticle < ActiveRecord::Migration
  def self.up
    add_column :articles, :abstract, :text
  end

  def self.down
    remove_column :articles, :abstract
  end
end
