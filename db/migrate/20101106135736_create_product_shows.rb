class CreateProductShows < ActiveRecord::Migration
  def self.up
    create_table :product_shows do |t|
      t.integer :category_id
      t.string :name
      t.string :location
      t.string :type
      t.text :memo
      t.integer :position
      t.integer :product_id

      t.timestamps
    end
  end

  def self.down
    drop_table :product_shows
  end
end
