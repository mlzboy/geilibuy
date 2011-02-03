class AddIndexForPostsaleComments < ActiveRecord::Migration
  def self.up
	add_index :postsale_comments,:product_id,:name=>"postsale_comments_product_id"
  end

  def self.down
	remove_index :postsale_comments,:name=>"postsale_comments_product_id"
  end
end
