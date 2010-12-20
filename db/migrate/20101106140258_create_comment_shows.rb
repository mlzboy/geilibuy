class CreateCommentShows < ActiveRecord::Migration
  def self.up
    create_table :comment_shows do |t|
      t.integer :category_id
      t.string :name
      t.string :location
      t.integer :postsale_comment_id
      t.integer :product_id
      t.integer :position

      t.timestamps
    end
  end

  def self.down
    drop_table :comment_shows
  end
end
