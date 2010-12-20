class RemoveCreativeToPostsaleComments < ActiveRecord::Migration
  def self.up
    remove_column :postsale_comments, :creative
    remove_column :postsale_comments, :feature
    remove_column :postsale_comments, :quality
    add_column :postsale_comments, :creative,:integer,:default=>0
    add_column :postsale_comments, :feature,:integer,:default=>0
    add_column :postsale_comments, :quality,:integer,:default=>0
  end

  def self.down
  end
end
