class AddMemoToCommentShows < ActiveRecord::Migration
  def self.up
    add_column :comment_shows, :memo, :text
    add_column :comment_shows, :kind, :string
  end

  def self.down
    remove_column :comment_shows, :memo
    remove_column :comment_shows, :kind
  end
end
