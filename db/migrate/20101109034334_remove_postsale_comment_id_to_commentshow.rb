class RemovePostsaleCommentIdToCommentshow < ActiveRecord::Migration
  def self.up
    remove_column :comment_shows, :postsale_comment_id
  end

  def self.down
    add_column :comment_shows, :postsale_comment_id, :integer
  end
end
