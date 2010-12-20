class CreateBrands < ActiveRecord::Migration
  def self.up
    create_table :brands do |t|
      t.string :name
      t.text :story
      
      t.string   :i1_file_name
      t.string   :i1_content_type
      t.integer  :i1_file_size
      t.datetime :i1_updated_at

      t.string   :i2_file_name
      t.string   :i2_content_type
      t.integer  :i2_file_size
      t.datetime :i2_updated_at
      
      t.timestamps
    end
  end

  def self.down
    drop_table :brands
  end
end
