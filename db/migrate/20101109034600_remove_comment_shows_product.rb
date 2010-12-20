class RemoveCommentShowsProduct < ActiveRecord::Migration
  def self.up
    #drop_table :comment_shows_products
    create_table :comment_shows_postsale_comments,:id=>false do |t|
      t.integer :comment_show_id
      t.integer :postsale_comment_id
      t.integer :position,:default=>0
    end    
  end

  def self.down
    #create_table :comment_shows_products,:id=>false do |t|
    #  t.integer :comment_show_id
    #  t.integer :product_id
    #  t.integer :position,:default=>0
    #end
    drop_table :comment_shows_postsale_comments
  end
end
