class RemovePostionToCommentShows < ActiveRecord::Migration
  def self.up
    remove_column :comment_shows, :position
  end

  def self.down
    add_column :comment_shows, :position, :integer
  end
end
