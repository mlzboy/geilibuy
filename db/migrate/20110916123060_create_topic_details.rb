class CreateTopicDetails < ActiveRecord::Migration
  def self.up
    create_table :topic_details do |t|
      t.text :content
      t.integer :topic_id
      t.integer :product_show_id
      t.integer :position,:default=>0
      t.timestamps
    end
  end

  def self.down
    drop_table :topic_details
  end
end
