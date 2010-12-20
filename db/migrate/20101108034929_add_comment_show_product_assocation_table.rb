class AddCommentShowProductAssocationTable < ActiveRecord::Migration
  def self.up
    create_table :comment_shows_products,:id=>false do |t|
      t.integer :comment_show_id
      t.integer :product_id
      t.integer :position,:default=>0
    end
  end

  def self.down
    drop_table :comment_shows_products
  end
end
