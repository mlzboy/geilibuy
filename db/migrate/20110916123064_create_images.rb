class CreateImages < ActiveRecord::Migration
  def self.up
    create_table :images do |t|
      t.integer :url_id
      t.string :img_url
      t.string :new_img_url
      t.boolean :success,:default=>false
      t.string :kind
      t.string :site

      t.timestamps
    end
  end

  def self.down
    drop_table :images
  end
end
