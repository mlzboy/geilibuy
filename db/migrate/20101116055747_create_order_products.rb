class CreateOrderProducts < ActiveRecord::Migration
  def self.up
    create_table :order_products do |t|
      t.string :name
      t.integer :product_id
      t.integer :order_id
      t.integer :num
      t.integer :s1,:default=>0
      t.boolean :score,:default=>0
      t.boolean :promotion,:default=>0
      t.decimal :p1,:precision => 15, :scale => 3, :default => 0.0
      t.decimal :p2,:precision => 15, :scale => 3, :default => 0.0
      t.decimal :p3,:precision => 15, :scale => 3, :default => 0.0
      t.decimal :p4,:precision => 15, :scale => 3, :default => 0.0
      t.decimal :p5,:precision => 15, :scale => 3, :default => 0.0
      t.string :sub_title

      t.timestamps
    end
  end

  def self.down
    drop_table :order_products
  end
end
