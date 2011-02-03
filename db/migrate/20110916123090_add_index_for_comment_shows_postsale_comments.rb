class AddIndexForCommentShowsPostsaleComments < ActiveRecord::Migration
  def self.up
	add_index :comment_shows_postsale_comments, [:comment_show_id, :postsale_comment_id,:position],:name=>"cspc_union_index"
  end

  def self.down
	remove_index :comment_shows_postsale_comments, :column=>[:comment_show_id, :postsale_comment_id,:position]
  end
end
