class AddHideToPostsaleComment < ActiveRecord::Migration
  def self.up
    add_column :postsale_comments, :hide, :boolean,:default=>0
  end

  def self.down
    remove_column :postsale_comments, :hide
  end
end
