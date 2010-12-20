class RemoveValueToPostsaleComments < ActiveRecord::Migration
  def self.up
    remove_column :postsale_comments, :value
    add_column :postsale_comments, :value, :boolean,:default=>0
  end

  def self.down
    add_column :postsale_comments, :value, :boolean
    remove_column :postsale_comments, :value
  end
end
