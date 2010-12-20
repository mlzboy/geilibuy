class CreateUploadPhotos < ActiveRecord::Migration
  def self.up
    create_table :upload_photos do |t|
      t.integer :user_id
      t.integer :product_id
      t.boolean :hide,:default=>1
      t.text :memo

      t.timestamps
    end
  end

  def self.down
    drop_table :upload_photos
  end
end
