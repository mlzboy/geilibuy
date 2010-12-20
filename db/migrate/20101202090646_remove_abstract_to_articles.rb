class RemoveAbstractToArticles < ActiveRecord::Migration
  def self.up
    remove_column :articles, :abstract
  end

  def self.down
    add_column :articles, :abstract, :text
  end
end
