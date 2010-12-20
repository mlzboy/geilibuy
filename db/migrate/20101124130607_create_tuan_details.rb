class CreateTuanDetails < ActiveRecord::Migration
  def self.up
    create_table :tuan_details do |t|
      t.string :title
      t.text :content
      t.integer :position,:default=>0
      t.string :kind
      t.timestamps
      t.integer:tuan_id
    end
  end

  def self.down
    drop_table :tuan_details
  end
end
