class RemoveProductIdToCommentShow < ActiveRecord::Migration
  def self.up
    remove_column :comment_shows, :product_id
  end

  def self.down
    add_column :comment_shows, :product_id, :integer
  end
end
