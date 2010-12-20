class CreatePostsaleComments < ActiveRecord::Migration
  def self.up
    create_table :postsale_comments do |t|
      t.text :content
      t.boolean :value
      t.text :reply
      t.string :ip
      t.integer :creative
      t.integer :feature
      t.integer :quality
      t.integer :product_id
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :postsale_comments
  end
end
